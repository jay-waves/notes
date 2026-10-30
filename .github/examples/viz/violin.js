import * as d3 from 'd3';

export default function render(container) {
  const groups = [
    { name: '方案 A', values: [22, 28, 31, 34, 35, 37, 39, 40, 42, 45, 48, 52, 57, 64] },
    { name: '方案 B', values: [31, 35, 38, 41, 44, 47, 48, 50, 52, 54, 56, 58, 61, 66] },
    { name: '方案 C', values: [18, 25, 30, 32, 36, 40, 42, 43, 45, 49, 55, 62, 69, 76] },
  ];
  const width = 640, height = 310, left = 58, bottom = 48;
  const x = d3.scaleBand(groups.map(d => d.name), [left, width - 24]).padding(.38);
  const y = d3.scaleLinear([10, 80], [height - bottom, 28]);
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '三个方案的分布小提琴图');
  svg.append('title').text('方案得分分布');
  svg.append('g').attr('class', 'grid').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(5).tickSize(-(width - left - 24)).tickFormat(''));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(5).tickSize(0).tickPadding(10));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - bottom})`)
    .call(d3.axisBottom(x).tickSize(0).tickPadding(12));
  const samples = d3.range(10, 81, 1);
  const bandwidth = 7;
  const kernel = value => Math.exp(-.5 * value * value) / Math.sqrt(2 * Math.PI);
  const densities = groups.map(group => samples.map(value => ({
    value,
    density: d3.mean(group.values, sample => kernel((value - sample) / bandwidth)) / bandwidth,
  })));
  const maxDensity = d3.max(densities, series => d3.max(series, d => d.density));
  const halfWidth = d3.scaleLinear([0, maxDensity], [0, x.bandwidth() * .46]);
  groups.forEach((group, i) => {
    const center = x(group.name) + x.bandwidth() / 2;
    const area = d3.area().curve(d3.curveCatmullRom.alpha(.5))
      .x0(d => center - halfWidth(d.density)).x1(d => center + halfWidth(d.density))
      .y(d => y(d.value));
    const marks = svg.append('g').attr('class', i === 1 ? 'accent' : 'series-2');
    marks.append('path').attr('d', area(densities[i])).attr('fill', 'var(--viz-series)')
      .attr('fill-opacity', .48).attr('stroke', 'var(--viz-series)').attr('stroke-width', 1.4);
    const median = d3.median(group.values);
    marks.append('line').attr('x1', center - 7).attr('x2', center + 7)
      .attr('y1', y(median)).attr('y2', y(median)).attr('stroke', 'var(--md-canvas)').attr('stroke-width', 2.2);
  });
}
