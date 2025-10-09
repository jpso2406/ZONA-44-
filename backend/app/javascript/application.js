// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import Rails from "@rails/ujs"
Rails.start()

import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('DOMContentLoaded', function () {
    // thumbs -> main image
    document.querySelectorAll('.thumb').forEach(btn => {
      btn.addEventListener('click', function () {
        document.querySelectorAll('.thumb').forEach(t=>t.classList.remove('active'));
        this.classList.add('active');
        const src = this.dataset.src;
        const main = document.getElementById('mainImage').querySelector('img');
        if (main) { main.src = src; }
      });
    });

    // quantity + addons and price calc
    const unit = parseInt('<%= @producto.precio.to_i %>', 10) || 0;
    const qtyInput = document.getElementById('qty');
    const qtyPlus = document.getElementById('qtyPlus');
    const qtyMinus = document.getElementById('qtyMinus');
    const addonCheckboxes = document.querySelectorAll('.addon-checkbox');
    const totalValue = document.getElementById('totalValue');

    function calcTotal() {
      const qty = Math.max(1, parseInt(qtyInput.value, 10) || 1);
      let addons = 0;
      addonCheckboxes.forEach(cb => { if (cb.checked) addons += parseInt(cb.dataset.price,10) || 0; });
      const total = (unit * qty) + addons;
      totalValue.innerText = total.toLocaleString();
      document.getElementById('precioUnitario').innerText = unit.toLocaleString();
    }

    qtyPlus.addEventListener('click', ()=> { qtyInput.value = parseInt(qtyInput.value || 1) + 1; calcTotal(); });
    qtyMinus.addEventListener('click', ()=> { qtyInput.value = Math.max(1, parseInt(qtyInput.value || 1) - 1); calcTotal(); });
    qtyInput.addEventListener('change', ()=> { if (qtyInput.value < 1) qtyInput.value = 1; calcTotal(); });
    addonCheckboxes.forEach(cb => cb.addEventListener('change', calcTotal));
    calcTotal();

    // sticky aside behavior on small screens: move below main if not enough space
    function adjustAside() {
      const aside = document.getElementById('orderPanel');
      if (!aside) return;
      if (window.innerWidth < 900) {
        aside.style.position = 'relative';
        aside.style.top = 'auto';
        aside.style.width = '100%';
      } else {
        aside.style.position = 'sticky';
        aside.style.top = '96px';
        aside.style.width = '';
      }
    }
    window.addEventListener('resize', adjustAside);
    adjustAside();
  });


  // carrito
  document.addEventListener('DOMContentLoaded', function () {
  // Animation when removing an item (works if rails-ujs remote forms used)
  document.querySelectorAll('.btn-icon-remove form, .qty-btn form').forEach(form => {
    form.addEventListener('ajax:success', function (e) {
      // if server responds with JSON instructing removal, you can handle it.
      // fallback: animate removal of parent li
      const btn = form.closest('form');
      const li = btn && btn.closest('.cart-item');
      if (li) {
        li.style.transition = 'transform .25s ease, opacity .25s ease';
        li.style.transform = 'translateX(20px) scale(.98)';
        li.style.opacity = '0';
        setTimeout(()=>{ li.remove(); updateSummary(); }, 260);
      } else {
        updateSummary();
      }
    });
  });

  // Helper to recalc totals client-side (best-effort; server is source of truth)
  function updateSummary() {
    // Simple fetch -> could call an endpoint to re-render summary; here we do naive recalculation from DOM
    let subtotal = 0;
    document.querySelectorAll('.cart-item').forEach(li=>{
      const qtyEl = li.querySelector('.qty-value');
      const qty = qtyEl ? parseInt(qtyEl.innerText || '0',10) : 0;
      const lineTotalText = li.querySelector('.line-total') ? li.querySelector('.line-total').innerText.replace(/\D/g,'') : '0';
      const lineTotal = parseInt(lineTotalText || '0', 10);
      subtotal += lineTotal;
    });
    const subtotalEl = document.querySelector('.summary-lines .line:nth-child(1) span:last-child');
    const impuestosEl = document.querySelector('.summary-lines .line:nth-child(2) span:last-child');
    const totalEl = document.querySelector('.summary-lines .total-line strong:last-child');

    if (subtotalEl) subtotalEl.innerText = '$' + subtotal.toLocaleString();
    const tax = Math.round(subtotal * 0.19);
    if (impuestosEl) impuestosEl.innerText = '$' + tax.toLocaleString();
    if (totalEl) totalEl.innerText = '$' + (subtotal + tax).toLocaleString();
  }

  // run once
  updateSummary();
});
