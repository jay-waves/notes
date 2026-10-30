import * as d3 from 'd3';

export default function render(container) {
  const data = [
    { name: '期初', start: 0, end: 42, color: 'series-1' },
    { name: '新增', start: 42, end: 65, color: 'series-2' },
    { name: '流失', start: 65, end: 53, color: 'accent-2' },
    { name: '调整', start: 53, end: 60, color: 'series-3' },
    { name: '期末', start: 0, end: 60, color: 'accent' },
  ];
  const width = 640, height = 300, left = 50, bottom = 46;
  const x = d3.scaleBand(data.map(d => d.name), [left, width - 25]).padding(0.43);
  const y = d3.scaleLinear([0, 80], [height - bottom, 30]);
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '从期初 42 到期末 60 的变化瀑布图');
  svg.append('title').text('指标变化构成');
  svg.append('g').attr('class', 'grid').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(4).tickSize(-(width - left - 25)).tickFormat(''));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).ticks(4).tickSize(0).tickPadding(10));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - bottom})`)
    .call(d3.axisBottom(x).tickSize(0).tickPadding(12));
  svg.selectAll('.connector').data(data.slice(0, -1)).join('line').attr('class', 'reference connector')
    .attr('x1', d => x(d.name) + x.bandwidth()).attr('x2', (d, i) => x(data[i + 1].name))
    .attr('y1', d => y(d.end)).attr('y2', d => y(d.end));
  const fills = { 'series-1': 'var(--viz-neutral-4)', 'series-2': 'var(--viz-neutral-2)',
    'series-3': 'var(--viz-neutral-3)', accent: 'var(--viz-accent)', 'accent-2': 'var(--viz-accent-2)' };
  svg.selectAll('rect').data(data).join('rect').attr('class', d => `bar ${d.color}`)
    .style('fill', d => fills[d.color])
    .attr('x', d => x(d.name)).attr('y', d => y(Math.max(d.start, d.end)))
    .attr('width', x.bandwidth()).attr('height', d => Math.abs(y(d.start) - y(d.end)))
    .append('title').text(d => `${d.name}：${d.end - d.start > 0 && d.start ? '+' : ''}${d.start ? d.end - d.start : d.end}`);
  svg.selectAll('.value').data(data).join('text').attr('class', 'value')
    .attr('x', d => x(d.name) + x.bandwidth() / 2).attr('y', d => y(Math.max(d.start, d.end)) - 8)
    .attr('text-anchor', 'middle').attr('fill', 'var(--viz-muted)').attr('font-size', 12)
    .text(d => d.start ? `${d.end - d.start > 0 ? '+' : ''}${d.end - d.start}` : d.end);
}
