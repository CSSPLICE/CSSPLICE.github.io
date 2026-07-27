(() => {
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  document.querySelectorAll('[data-exclusive-accordion]').forEach((accordion) => {
    const panels = [...accordion.querySelectorAll(':scope > details')];

    const contentFor = (panel) => panel.querySelector(':scope > .resource-accordion-content');

    const finish = (content) => {
      content.getAnimations().forEach((animation) => animation.cancel());
      content.style.removeProperty('height');
      content.style.removeProperty('opacity');
      content.style.removeProperty('overflow');
    };

    const closePanel = async (panel) => {
      if (!panel.open) return;
      const content = contentFor(panel);
      if (!content || reducedMotion.matches) {
        panel.open = false;
        return;
      }

      finish(content);
      content.style.overflow = 'hidden';
      const animation = content.animate(
        [
          { height: `${content.scrollHeight}px`, opacity: 1 },
          { height: '0px', opacity: 0 }
        ],
        { duration: 240, easing: 'cubic-bezier(0.4, 0, 0.2, 1)' }
      );

      try { await animation.finished; } catch (_) { return; }
      panel.open = false;
      finish(content);
    };

    const openPanel = async (panel) => {
      if (panel.open) return;
      const content = contentFor(panel);
      panel.open = true;
      if (!content || reducedMotion.matches) return;

      finish(content);
      content.style.overflow = 'hidden';
      const targetHeight = content.scrollHeight;
      const animation = content.animate(
        [
          { height: '0px', opacity: 0 },
          { height: `${targetHeight}px`, opacity: 1 }
        ],
        { duration: 280, easing: 'cubic-bezier(0.22, 1, 0.36, 1)' }
      );

      try { await animation.finished; } catch (_) { return; }
      finish(content);
    };

    panels.forEach((panel) => {
      const summary = panel.querySelector(':scope > summary');
      summary?.addEventListener('click', (event) => {
        event.preventDefault();
        if (panel.open) {
          closePanel(panel);
          return;
        }

        panels.forEach((otherPanel) => {
          if (otherPanel !== panel) closePanel(otherPanel);
        });
        openPanel(panel);
      });
    });
  });
})();
