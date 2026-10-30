import * as d3 from 'd3';

export default function render(container) {
  const data = [
    { name: '春', value: 32 }, { name: '夏', value: 58 },
    { name: '秋', value: 46 }, { name: '冬', value: 24 },
  ];
  const width = 640, height = 280;
  const x = d3.scaleBand(data.map(d => d.name), [48, width - 20]).padding(0.35);
  const y = d3.scaleLinear([0, 60], [height - 36, 24]);
  const svg = d3.select(container).append('svg')
    .attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '四季数值柱状图');
  svg.append('title').text('四季数值');
  svg.append('g').attr('class', 'grid').attr('transform', 'translate(48,0)')
    .call(d3.axisLeft(y).ticks(4).tickSize(-(width - 68)).tickFormat(''));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - 36})`)
    .call(d3.axisBottom(x).tickSize(0).tickPadding(12));
  svg.append('g').attr('class', 'axis').attr('transform', 'translate(48,0)')
    .call(d3.axisLeft(y).ticks(4).tickSize(0).tickPadding(10));
  svg.selectAll('rect').data(data).join('rect').attr('class', (d, i) => `bar ${i === 1 ? 'accent' : 'series-1'}`)
    .attr('x', d => x(d.name)).attr('y', d => y(d.value))
    .attr('width', x.bandwidth()).attr('height', d => y(0) - y(d.value)).attr('rx', 1)
    .attr('tabindex', 0)
    .append('title').text(d => `${d.name}：${d.value}`);
  d3.select(container).append('p').attr('class', 'caption')
    .text('四季数值。');
}
