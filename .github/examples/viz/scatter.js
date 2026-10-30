import * as d3 from 'd3';

export default function render(container) {
  const data = [
    { x: 2, y: 26 }, { x: 3, y: 31 }, { x: 4, y: 34 }, { x: 5, y: 37 },
    { x: 6, y: 40 }, { x: 7, y: 43 }, { x: 8, y: 45 }, { x: 9, y: 49 },
    { x: 3, y: 28 }, { x: 5, y: 35 }, { x: 7, y: 41 }, { x: 9, y: 46 },
    { x: 4, y: 32 }, { x: 6, y: 38 }, { x: 8, y: 47 }, { x: 10, y: 51 },
  ];
  const width = 640, height = 300, left = 54, bottom = 46;
  const x = d3.scaleLinear([0, 11], [left, width - 25]);
  const y = d3.scaleLinear([20, 56], [height - bottom, 28]);
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '十六个样本的散点图');
  svg.append('title').text('样本关系');
  svg.append('g').attr('class', 'grid').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(4).tickSize(-(width - left - 25)).tickFormat(''));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(4).tickSize(0).tickPadding(10));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - bottom})`)
    .call(d3.axisBottom(x).ticks(6).tickSize(0).tickPadding(12));
  svg.append('g').attr('class', 'accent').selectAll('circle').data(data).join('circle')
    .attr('class', 'point').attr('cx', d => x(d.x)).attr('cy', d => y(d.y)).attr('r', 4.5)
    .append('title').text(d => `样本：${d.x}，数值：${d.y}`);
}
