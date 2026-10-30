import * as d3 from 'd3';

export default function render(container) {
  const groups = [
    { name: '甲组', values: [28, 19, 13] },
    { name: '乙组', values: [18, 26, 16] },
    { name: '丙组', values: [23, 15, 22] },
  ];
  const colors = ['series-2', 'series-3', 'accent'];
  const svg = d3.select(container).append('svg').attr('viewBox', '0 0 600 310')
    .attr('role', 'img').attr('aria-label', '三组数据的环形堆叠图');
  svg.append('title').text('各组构成对比');
  const pie = d3.pie().sort(null).value(d => d);
  const center = svg.append('g').attr('transform', 'translate(185,155)');
  groups.forEach((group, ring) => {
    const inner = 40 + ring * 31, outer = inner + 25;
    const arc = d3.arc().innerRadius(inner).outerRadius(outer).padAngle(.018);
    center.selectAll(`.ring-${ring}`).data(pie(group.values)).join('path')
      .attr('class', (d, i) => `slice ${colors[i]}`)
      .attr('d', arc).append('title')
      .text(d => `${group.name} · 类别 ${d.index + 1}：${d.value}`);
  });
  center.append('text').attr('text-anchor', 'middle').attr('y', -2)
    .attr('fill', 'currentColor').text('构成');
  center.append('text').attr('text-anchor', 'middle').attr('y', 17)
    .attr('fill', 'var(--viz-muted)').text('由内至外：甲、乙、丙');
  const legend = svg.append('g').attr('class', 'legend').attr('transform', 'translate(410,95)');
  const entries = legend.selectAll('g').data(colors).join('g').attr('transform', (d, i) => `translate(0,${i * 35})`);
  entries.append('rect').attr('class', d => `mark ${d}`).attr('width', 11).attr('height', 11).attr('y', -9);
  entries.append('text').attr('x', 20).attr('fill', 'currentColor').text((d, i) => `类别 ${i + 1}`);
}
