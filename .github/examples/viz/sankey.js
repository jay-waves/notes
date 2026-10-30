import * as d3 from 'd3';

export default function render(container) {
  const nodes = [
    { name: '来源 A', x: 70, y: 62 }, { name: '来源 B', x: 70, y: 190 },
    { name: '过程一', x: 285, y: 45 }, { name: '过程二', x: 285, y: 155 },
    { name: '结果 A', x: 500, y: 82 }, { name: '结果 B', x: 500, y: 190 },
  ];
  const links = [
    { source: 0, target: 2, value: 22 }, { source: 0, target: 3, value: 10 },
    { source: 1, target: 2, value: 8 }, { source: 1, target: 3, value: 20 },
    { source: 2, target: 4, value: 19 }, { source: 2, target: 5, value: 11 },
    { source: 3, target: 4, value: 11 }, { source: 3, target: 5, value: 19 },
  ];
  const width = 620, height = 290, nodeWidth = 14, nodeHeight = 42;
  const offsets = Array(nodes.length).fill(0);
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '来源经过两个过程流向两个结果的桑基图');
  svg.append('title').text('流量路径');
  const path = link => {
    const source = nodes[link.source], target = nodes[link.target];
    const y0 = source.y + 10 + offsets[link.source];
    const y1 = target.y + 10 + offsets[link.target];
    offsets[link.source] += 8;
    offsets[link.target] += 8;
    const middle = (source.x + nodeWidth + target.x) / 2;
    return `M${source.x + nodeWidth},${y0} C${middle},${y0} ${middle},${y1} ${target.x},${y1}`;
  };
  svg.append('g').selectAll('path').data(links).join('path').attr('class', 'sankey-link')
    .attr('fill', 'none').attr('stroke', '#91b8ca').attr('stroke-opacity', .52)
    .attr('stroke-width', d => 1.5 + d.value * .55).attr('d', path)
    .append('title').text(d => `流量：${d.value}`);
  const group = svg.append('g').selectAll('g').data(nodes).join('g').attr('transform', d => `translate(${d.x},${d.y})`);
  group.append('rect').attr('class', (d, i) => `sankey-node ${i === 2 || i === 3 ? 'accent' : 'series-1'}`)
    .attr('fill', (d, i) => i === 2 || i === 3 ? '#527f70' : '#6596ad')
    .attr('stroke', 'var(--md-canvas)').attr('stroke-width', 1)
    .attr('width', nodeWidth).attr('height', nodeHeight).attr('rx', 1);
  group.append('text').attr('x', d => d.x < width / 2 ? -8 : nodeWidth + 8).attr('y', 26)
    .attr('text-anchor', d => d.x < width / 2 ? 'end' : 'start').attr('fill', 'currentColor').text(d => d.name);
}
