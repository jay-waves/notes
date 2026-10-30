import * as d3 from 'd3';

export const samples = [
  { name: '方案 A', values: [18, 32, 35, 38, 39, 41, 43, 45, 46, 48, 51, 54, 57, 62, 86] },
  { name: '方案 B', values: [38, 42, 45, 48, 49, 50, 52, 53, 54, 55, 57, 59, 61, 65, 70] },
  { name: '方案 C', values: [15, 25, 28, 32, 35, 37, 40, 42, 44, 48, 52, 58, 63, 68, 93] },
  { name: '方案 D', values: [28, 52, 55, 57, 58, 59, 60, 61, 62, 64, 65, 67, 69, 72, 88] },
];

export function summarize(sample) {
  const values = [...sample.values].sort(d3.ascending);
  const q1 = d3.quantileSorted(values, 0.25);
  const median = d3.quantileSorted(values, 0.5);
  const q3 = d3.quantileSorted(values, 0.75);
  const iqr = q3 - q1;
  const inliers = values.filter(v => v >= q1 - 1.5 * iqr && v <= q3 + 1.5 * iqr);
  return { ...sample, q1, median, q3, low: d3.min(inliers), high: d3.max(inliers),
    outliers: values.filter(v => v < q1 - 1.5 * iqr || v > q3 + 1.5 * iqr) };
}

export default function render(container) {
  const data = samples.map(summarize);
  const width = 720, height = 380;
  const x = d3.scaleBand(data.map(d => d.name), [64, width - 24]).padding(0.48);
  const y = d3.scaleLinear([0, 100], [height - 48, 36]);
  const svg = d3.select(container).append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '四种方案的箱型图，展示中位数、四分位区间和离群点');
  svg.append('title').text('四种方案的分布对比');
  svg.append('g').attr('class', 'grid').attr('transform', 'translate(64,0)')
    .call(d3.axisLeft(y).ticks(5).tickSize(-(width - 88)).tickFormat(''));
  svg.append('g').attr('class', 'axis').attr('transform', 'translate(64,0)')
    .call(d3.axisLeft(y).ticks(5).tickSize(0).tickPadding(12));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - 48})`)
    .call(d3.axisBottom(x).tickSize(0).tickPadding(16));
  svg.append('text').attr('x', 64).attr('y', 16)
    .attr('fill', 'var(--viz-muted)').text('评分 / 分');

  const format = d3.format('.1f');
  const groups = svg.selectAll('.boxplot-group').data(data).join('g')
    .attr('class', (d, i) => `boxplot-group ${i === 3 ? 'accent' : 'series-1'}`)
    .attr('transform', d => `translate(${x(d.name) + x.bandwidth() / 2},0)`)
    .attr('tabindex', 0).attr('role', 'img')
    .attr('aria-label', d => `${d.name}：中位数 ${format(d.median)}，下四分位 ${format(d.q1)}，上四分位 ${format(d.q3)}，离群点 ${d.outliers.length} 个`);
  const boxWidth = Math.min(x.bandwidth(), 72);
  groups.append('line').attr('class', 'whisker')
    .attr('y1', d => y(d.low)).attr('y2', d => y(d.high));
  for (const bound of ['low', 'high']) {
    groups.append('line').attr('class', 'whisker').attr('x1', -boxWidth / 4).attr('x2', boxWidth / 4)
      .attr('y1', d => y(d[bound])).attr('y2', d => y(d[bound]));
  }
  groups.append('rect').attr('class', 'box')
    .attr('x', -boxWidth / 2).attr('width', boxWidth)
    .attr('y', d => y(d.q3)).attr('height', d => y(d.q1) - y(d.q3))
    .attr('rx', 1);
  groups.append('line').attr('class', 'median')
    .attr('x1', -boxWidth / 2).attr('x2', boxWidth / 2)
    .attr('y1', d => y(d.median)).attr('y2', d => y(d.median));
  groups.selectAll('.outlier').data(d => d.outliers).join('circle').attr('class', 'outlier')
    .attr('cy', d => y(d)).attr('r', 3.5)
    .append('title').text(d => `离群点：${d}`);
  groups.append('title').text(d => `${d.name} · n=${d.values.length}\n中位数 ${format(d.median)}\nQ1–Q3 ${format(d.q1)}–${format(d.q3)}\n须线 ${d.low}–${d.high}\n离群点：${d.outliers.join('、') || '无'}`);

  const caption = d3.select(container).append('p').attr('class', 'caption')
    .attr('aria-live', 'polite');
  const hint = '示例数据，每组 15 个观测值。箱体：Q1–Q3；横线：中位数；须线：1.5 × IQR 内的最远观测值；空心点：离群点。';
  caption.text(hint);
}

export function hydrate(container) {
  const groups = d3.select(container).selectAll('.boxplot-group').data(samples.map(summarize));
  const caption = d3.select(container).select('.caption');
  const hint = caption.text();
  const format = d3.format('.1f');
  groups.on('pointerenter focus', function (event, d) {
    d3.select(this).select('.box').attr('opacity', 0.65);
    caption.text(`${d.name} · 中位数 ${format(d.median)} · Q1–Q3 ${format(d.q1)}–${format(d.q3)} · 须线 ${d.low}–${d.high} · 离群点 ${d.outliers.length} 个`);
  }).on('pointerleave blur', function () {
    d3.select(this).select('.box').attr('opacity', 1);
    caption.text(hint);
  });
}
