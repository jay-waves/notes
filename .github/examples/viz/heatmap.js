import * as d3 from 'd3';

export default function render(container) {
  const rows = ['甲', '乙', '丙', '丁', '戊'];
  const columns = ['一月', '二月', '三月', '四月', '五月', '六月'];
  const values = [
    [12, 18, 22, 31, 28, 35], [20, 24, 19, 33, 39, 42], [8, 14, 25, 27, 34, 38],
    [17, 21, 29, 24, 37, 45], [10, 19, 23, 32, 30, 40],
  ];
  const data = rows.flatMap((row, j) => columns.map((column, i) => ({ row, column, value: values[j][i] })));
  const width = 640, height = 300, left = 58, top = 30, right = 24, bottom = 44;
  const x = d3.scaleBand(columns, [left, width - right]).paddingInner(.055);
  const y = d3.scaleBand(rows, [top, height - bottom]).paddingInner(.08);
  const color = d3.scaleQuantize([8, 45], ['heat-low', 'heat-mid', 'heat-high']);
  const fills = { 'heat-low': '#dce7eb', 'heat-mid': '#8fb5c7', 'heat-high': '#47788f' };
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '五组数据在六个月中的热力图');
  svg.append('title').text('月度分布热力图');
  svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${height - bottom})`)
    .call(d3.axisBottom(x).tickSize(0).tickPadding(12));
  svg.append('g').attr('class', 'axis').attr('transform', `translate(${left},0)`)
    .call(d3.axisLeft(y).tickSize(0).tickPadding(12));
  const cells = svg.append('g').selectAll('rect').data(data).join('rect')
    .attr('class', d => `heat-cell ${color(d.value)}`)
    .attr('fill', d => fills[color(d.value)])
    .attr('stroke', 'var(--md-canvas)').attr('stroke-width', 1)
    .attr('x', d => x(d.column)).attr('y', d => y(d.row))
    .attr('width', x.bandwidth()).attr('height', y.bandwidth()).attr('rx', 1);
  cells.append('title').text(d => `${d.row} · ${d.column}：${d.value}`);
  svg.append('text').attr('x', width - right).attr('y', height - 8).attr('text-anchor', 'end')
    .attr('fill', 'var(--viz-muted)').text('低  ·  数值  ·  高');
}
