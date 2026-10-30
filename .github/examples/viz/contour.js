import * as d3 from 'd3';

export default function render(container) {
  const width = 640, height = 340, nx = 100, ny = 56;
  const peaks = [
    { x: .30, y: .38, sx: .12, sy: .19, weight: 1 },
    { x: .68, y: .62, sx: .19, sy: .13, weight: .82 },
    { x: .77, y: .27, sx: .09, sy: .11, weight: .52 },
  ];
  const values = new Array(nx * ny);
  for (let j = 0; j < ny; j++) for (let i = 0; i < nx; i++) {
    const px = i / (nx - 1), py = j / (ny - 1);
    values[j * nx + i] = peaks.reduce((sum, p) => {
      const dx = (px - p.x) / p.sx, dy = (py - p.y) / p.sy;
      return sum + p.weight * Math.exp(-.5 * (dx * dx + dy * dy));
    }, 0);
  }
  const svg = d3.select(container).append('svg').attr('viewBox', `0 0 ${width} ${height}`)
    .attr('role', 'img').attr('aria-label', '由三个峰值构成的二维等值线图');
  svg.append('title').text('空间强度等值线');
  const plot = { x: 54, y: 20, width: width - 78, height: height - 62 };
  const projection = d3.geoTransform({
    point(x, y) { this.stream.point(plot.x + x * plot.width / nx, plot.y + y * plot.height / ny); },
  });
  const path = d3.geoPath(projection);
  const contours = d3.contours().size([nx, ny]).thresholds(8)(values);
  const max = d3.max(contours, d => d.value);
  const shades = d3.scaleLinear([d3.min(contours, d => d.value), max], ['#d7e4e9', '#3f7189']);
  svg.append('g').selectAll('path').data(contours).join('path').attr('d', path)
    .attr('fill', d => shades(d.value)).attr('fill-opacity', .72)
    .attr('stroke', d => d.value === max ? 'var(--viz-accent)' : 'var(--md-canvas)')
    .attr('stroke-width', d => d.value === max ? 1.8 : .8)
    .append('title').text(d => `强度等值：${d.value.toFixed(2)}`);
  svg.append('text').attr('x', plot.x + plot.width / 2).attr('y', height - 8)
    .attr('text-anchor', 'middle').attr('fill', 'var(--viz-muted)').text('空间位置 X');
  svg.append('text').attr('transform', `translate(15,${plot.y + plot.height / 2}) rotate(-90)`)
    .attr('text-anchor', 'middle').attr('fill', 'var(--viz-muted)').text('空间位置 Y');
}
