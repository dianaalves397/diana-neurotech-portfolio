(() => {
  'use strict';

  const scrollLine = document.getElementById('scrollLine');
  const updateScroll = () => {
    const max = document.documentElement.scrollHeight - window.innerHeight;
    const progress = max > 0 ? Math.min(1, Math.max(0, window.scrollY / max)) : 0;
    if (scrollLine) scrollLine.style.transform = `scaleX(${progress})`;
  };
  updateScroll();
  window.addEventListener('scroll', updateScroll, { passive: true });
  window.addEventListener('resize', updateScroll);

  const canvas = document.getElementById('neuralField');
  if (canvas instanceof HTMLCanvasElement) {
    const ctx = canvas.getContext('2d');
    if (ctx) {
      let frame = 0;
      let animationId = 0;
      let width = 1;
      let height = 1;
      let pointer = { x: 0.6, y: 0.45, active: false };
      const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      const nodes = Array.from({ length: 54 }, (_, i) => ({
        x: ((i * 47) % 101) / 100,
        y: ((i * 71 + 13) % 97) / 96,
        r: 1.5 + (i % 5) * 0.55,
        phase: (i * 0.41) % (Math.PI * 2)
      }));

      const resizeCanvas = () => {
        const rect = canvas.getBoundingClientRect();
        const dpr = Math.min(window.devicePixelRatio || 1, 2);
        width = Math.max(1, rect.width);
        height = Math.max(1, rect.height);
        canvas.width = Math.floor(width * dpr);
        canvas.height = Math.floor(height * dpr);
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      };

      const draw = () => {
        frame += reduced ? 0 : 0.012;
        ctx.clearRect(0, 0, width, height);
        const points = nodes.map((node) => {
          const px = pointer.x * width;
          const py = pointer.y * height;
          const bx = node.x * width;
          const by = node.y * height;
          const dx = bx - px;
          const dy = by - py;
          const dist = Math.max(40, Math.hypot(dx, dy));
          const force = pointer.active ? Math.min(18, 900 / dist) : 0;
          return {
            x: bx + Math.cos(node.phase + frame) * 5 + (dx / dist) * force,
            y: by + Math.sin(node.phase * 1.7 + frame) * 5 + (dy / dist) * force,
            r: node.r
          };
        });

        for (let i = 0; i < points.length; i += 1) {
          for (let j = i + 1; j < points.length; j += 1) {
            const a = points[i];
            const b = points[j];
            const d = Math.hypot(a.x - b.x, a.y - b.y);
            if (d < Math.min(150, width * 0.23)) {
              const alpha = (1 - d / 150) * 0.22;
              ctx.strokeStyle = `rgba(205,255,73,${alpha})`;
              ctx.lineWidth = 0.75;
              ctx.beginPath();
              ctx.moveTo(a.x, a.y);
              ctx.lineTo(b.x, b.y);
              ctx.stroke();
            }
          }
        }
        points.forEach((p, index) => {
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.r + (index % 8 === 0 ? 1.4 : 0), 0, Math.PI * 2);
          ctx.fillStyle = index % 7 === 0 ? '#a98bff' : '#cdff49';
          ctx.fill();
        });
        if (!reduced) animationId = window.requestAnimationFrame(draw);
      };

      canvas.addEventListener('pointermove', (event) => {
        const rect = canvas.getBoundingClientRect();
        pointer = {
          x: Math.max(0, Math.min(1, (event.clientX - rect.left) / rect.width)),
          y: Math.max(0, Math.min(1, (event.clientY - rect.top) / rect.height)),
          active: true
        };
        if (reduced) draw();
      });
      canvas.addEventListener('pointerleave', () => {
        pointer.active = false;
        if (reduced) draw();
      });
      window.addEventListener('resize', resizeCanvas);
      resizeCanvas();
      draw();
      window.addEventListener('pagehide', () => window.cancelAnimationFrame(animationId), { once: true });
    }
  }

  document.querySelectorAll('.tilt-card').forEach((card) => {
    card.addEventListener('pointermove', (event) => {
      if (!(event instanceof PointerEvent) || event.pointerType === 'touch') return;
      const rect = card.getBoundingClientRect();
      const rx = ((event.clientY - rect.top) / rect.height - 0.5) * -5;
      const ry = ((event.clientX - rect.left) / rect.width - 0.5) * 6;
      card.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-4px)`;
    });
    card.addEventListener('pointerleave', () => { card.style.transform = ''; });
  });

  const label = document.getElementById('activeNodeLabel');
  const text = document.getElementById('activeNodeText');
  const researchNodes = Array.from(document.querySelectorAll('.research-node'));
  researchNodes.forEach((node) => {
    node.addEventListener('click', () => {
      researchNodes.forEach((item) => {
        item.classList.remove('active');
        item.setAttribute('aria-pressed', 'false');
      });
      node.classList.add('active');
      node.setAttribute('aria-pressed', 'true');
      if (label) label.textContent = node.getAttribute('data-label') || '';
      if (text) text.textContent = node.getAttribute('data-text') || '';
    });
  });
})();
