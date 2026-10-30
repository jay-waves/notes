(() => {
    const script = document.currentScript;
    const root = new URL('../../', script.src);
    let loaded = false;
    let touchY = null;

    async function reveal(amount) {
        if (loaded || amount <= 0 || window.scrollY + window.innerHeight < document.documentElement.scrollHeight - 2) return;
        loaded = true;
        try {
            const response = await fetch(new URL('related-notes.json', script.src));
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            const data = await response.json();
            const path = decodeURIComponent(location.pathname.slice(root.pathname.length));
            const entries = data[path] || [];
            if (!entries.length) return;
            const panel = document.createElement('nav');
            panel.className = 'related-notes';
            panel.setAttribute('aria-label', '相关文章');
            const title = document.createElement('h2');
            title.textContent = 'Related Notes';
            panel.append(title);
            const paragraph = document.createElement('p');
            for (const entry of entries) {
                const link = document.createElement('a');
                link.href = new URL(entry.url.split('/').map(encodeURIComponent).join('/'), root).href;
                link.textContent = entry.source;
                if (paragraph.childNodes.length) paragraph.append(document.createElement('br'));
                paragraph.append(link);
            }
            panel.append(paragraph);
            (document.querySelector('main#content') || document.body).append(panel);
        } catch (error) {
            loaded = false;
            console.error('Could not load related notes:', error);
        }
    }
    window.addEventListener('wheel', event => reveal(event.deltaY), { passive: true });
    window.addEventListener('touchstart', event => { touchY = event.touches[0].clientY; }, { passive: true });
    window.addEventListener('touchmove', event => {
        const next = event.touches[0].clientY;
        if (touchY !== null) reveal(touchY - next);
        touchY = next;
    }, { passive: true });
})();
