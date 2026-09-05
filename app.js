(() => {
  const code = document.getElementById('loadstringCode');
  const copyButton = document.getElementById('btnCopyLoadstring');
  const status = document.getElementById('copyStatus');

  const announce = (message, restore = false) => {
    status.textContent = message;
    if (restore) window.setTimeout(() => { status.textContent = ''; }, 2200);
  };

  copyButton?.addEventListener('click', async () => {
    const value = code?.textContent?.trim() || '';
    try {
      await navigator.clipboard.writeText(value);
      copyButton.textContent = 'Loadstring copié';
      announce('Le loadstring est dans ton presse-papiers.', true);
    } catch (_) {
      announce('Copie automatique indisponible : sélectionne le texte manuellement.', false);
    }
    window.setTimeout(() => { copyButton.textContent = 'Copier le loadstring'; }, 2200);
  });

  document.querySelectorAll('a[href^="#"]').forEach((link) => {
    link.addEventListener('click', (event) => {
      const target = document.querySelector(link.getAttribute('href'));
      if (!target) return;
      event.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      target.setAttribute('tabindex', '-1');
      target.focus({ preventScroll: true });
    });
  });
})();
