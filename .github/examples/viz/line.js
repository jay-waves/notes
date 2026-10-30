import * as d3 from 'd3';

export default function render(container) {
  const months = ['一月', '二月', '三月', '四月', '五月', '六月'];
  const series = [
    { name: '对照组', color: 'series-1', values: [31, 34, 33, 38, 39, 42] },
    { name: '实验组', color: 'accent', values: [30, 36, 40, 43, 49, 54] },
  ];
  const width = 640, height = 300, left = 54, right = 35, bottom = 48;
  const x = d3.scalePoint(months, [left, width - right]);
  const y = d3.scaleLinear([20, 60], [height - bottom, 40]);
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '实验组与对照组六个月的趋势折线图');
  svg.append('title').text('两组数据趋势');
  svg.append('g').attr('class', 'grid').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(4).tickSize(-(width - left - right)).tickFormat(''));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(4).tickSize(0).tickPadding(10));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - bottom})`)
    .call(d3.axisBottom(x).tickSize(0).tickPadding(12));
  const line = d3.line().x((d, i) => x(months[i])).y(d => y(d));
  for (const item of series) {
    const group = svg.append('g').attr('class', item.color);
    group.append('path').attr('class', 'line').attr('d', line(item.values));
    group.selectAll('circle').data(item.values).join('circle').attr('class', 'point')
      .attr('cx', (d, i) => x(months[i])).attr('cy', y).attr('r', 3);
  }
  const legend = svg.append('g').attr('class', 'legend').attr('transform', 'translate(345,18)');
  const entries = legend.selectAll('g').data(series).join('g').attr('transform', (d, i) => `translate(${i * 115},0)`);
  entries.append('line').attr('class', d => `line ${d.color}`).attr('x2', 20);
  entries.append('text').attr('x', 27).attr('y', 4).attr('fill', 'currentColor').text(d => d.name);
}
