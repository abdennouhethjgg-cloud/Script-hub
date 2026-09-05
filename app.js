(() => {
  const DURATION = 30, SKIP_AT = 20;
  const $ = id => document.getElementById(id);
  const bar = $('barFill'), pct = $('loadPct'), time = $('loadTime'), status = $('loadStatus'), wait = $('skipWait'), skip = $('skipBtn');
  let start = performance.now(), done = false, unlocked = false, raf;
  function finish(skipped = false) { if (done) return; done = true; cancelAnimationFrame(raf); bar.style.width='100%'; pct.textContent='100%'; time.textContent='0s'; status.textContent=skipped?'Skipped!':'Ready!'; wait.textContent=''; skip.disabled=true; skip.textContent=skipped?'SKIPPED':'DONE'; }
  function frame(now) { if(done)return; const elapsed=(now-start)/1000, progress=Math.min(1,elapsed/DURATION); bar.style.width=(progress*100).toFixed(1)+'%'; pct.textContent=Math.round(progress*100)+'%'; time.textContent=Math.max(0,Math.ceil(DURATION-elapsed))+'s'; if(elapsed>=SKIP_AT&&!unlocked){unlocked=true;skip.disabled=false;wait.textContent='';}else if(!unlocked){wait.textContent='Skip in '+Math.max(0,Math.ceil(SKIP_AT-elapsed))+'s...';} if(progress>=1){finish();return;} raf=requestAnimationFrame(frame); }
  skip.addEventListener('click',()=>{if(!skip.disabled)finish(true)}); raf=requestAnimationFrame(frame);
  $('btnTopGet').addEventListener('click',()=>document.getElementById('download').scrollIntoView({behavior:'smooth'}));
  $('btnCopyPath').addEventListener('click',async()=>{const b=$('btnCopyPath');try{await navigator.clipboard.writeText('EL2B_ALL_GEAR.lua');b.textContent='Copié !';}catch(_){b.textContent='EL2B_ALL_GEAR.lua';}setTimeout(()=>b.textContent='Copier le nom du fichier',1500);});
})();
