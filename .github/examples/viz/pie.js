import * as d3 from 'd3';

export default function render(container) {
  const data = [
    { name: '研究', value: 38, color: 'accent' },
    { name: '开发', value: 27, color: 'series-1' },
    { name: '运营', value: 21, color: 'series-2' },
    { name: '其他', value: 14, color: 'series-3' },
  ];
  const svg = d3.select(container).append('svg').attr('viewBox', '0 0 600 260')
    .attr('role', 'img').attr('aria-label', '资源分配环形图：研究 38%，开发 27%，运营 21%，其他 14%');
  svg.append('title').text('资源分配');
  const pie = d3.pie().sort(null).value(d => d.value);
  const arc = d3.arc().innerRadius(64).outerRadius(104).padAngle(0.018);
  const center = svg.append('g').attr('transform', 'translate(160,130)');
  center.selectAll('path').data(pie(data)).join('path')
    .attr('class', d => `slice ${d.data.color}`).attr('d', arc)
    .append('title').text(d => `${d.data.name}：${d.data.value}%`);
  center.append('text').attr('class', 'viz-total').attr('text-anchor', 'middle').attr('y', -4)
    .attr('fill', 'currentColor').text('100%');
  center.append('text').attr('text-anchor', 'middle').attr('y', 17)
    .attr('fill', 'var(--viz-muted)').attr('font-size', 12).text('资源总量');
  const legend = svg.append('g').attr('transform', 'translate(325,55)').attr('class', 'legend');
  const rows = legend.selectAll('g').data(data).join('g').attr('transform', (d, i) => `translate(0,${i * 42})`);
  rows.append('rect').attr('class', d => `mark ${d.color}`).attr('width', 10).attr('height', 10).attr('y', -8);
  rows.append('text').attr('x', 20).attr('fill', 'currentColor').text(d => d.name);
  rows.append('text').attr('x', 155).attr('text-anchor', 'end').attr('fill', 'var(--viz-muted)').text(d => `${d.value}%`);
}
