(() => {
    const panel = document.querySelector('.related-notes');
    if (!panel) return;
    let pressure = 0;
    let last = 0;
    let touchY = null;
    const push = amount => {
        if (panel.open || amount <= 0 || window.scrollY + window.innerHeight < document.documentElement.scrollHeight - 2) return;
        const now = Date.now();
        pressure = now - last > 800 ? amount : pressure + amount;
        last = now;
        if (pressure >= 120) panel.open = true;
    };
    window.addEventListener('wheel', event => push(event.deltaY), { passive: true });
    window.addEventListener('touchstart', event => { touchY = event.touches[0].clientY; }, { passive: true });
    window.addEventListener('touchmove', event => {
        const next = event.touches[0].clientY;
        if (touchY !== null) push(touchY - next);
        touchY = next;
    }, { passive: true });
})();
