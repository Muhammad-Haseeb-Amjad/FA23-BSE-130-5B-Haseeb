<!DOCTYPE html>
<html lang="en" id="home">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CUI_CHAT | COMSATS University Islamabad Social Platform</title>
<meta name="description" content="CUI_CHAT is a verified social networking platform for COMSATS University Islamabad students and faculty, connecting campuses through profiles, communities, posts, rooms, chats, events, and secure admin-approved access.">
<meta name="keywords" content="CUI_CHAT, COMSATS, COMSATS University Islamabad, CUI Chat, university social platform, COMSATS social network, student community, faculty platform, campus community">
<meta name="author" content="CUI_CHAT Team">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://cuichat.online/">
<meta name="theme-color" content="#00113a">
<link rel="icon" type="image/png" href="{{ asset('asset/cuichat-logo.png') }}?v=20260514-logo2">
<link rel="shortcut icon" type="image/png" href="{{ asset('asset/cuichat-logo.png') }}?v=20260514-logo2">
<link rel="apple-touch-icon" href="{{ asset('asset/cuichat-logo.png') }}?v=20260514-logo2">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cuichat.online/">
<meta property="og:title" content="CUI_CHAT | COMSATS University Islamabad Social Platform">
<meta property="og:description" content="A verified social networking platform for COMSATS students and faculty, connecting campuses through secure profiles, communities, posts, rooms, chats, events, and admin-approved access.">
<meta property="og:image" content="{{ asset('asset/cuichat-logo.png') }}">
<meta property="og:site_name" content="CUI_CHAT">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="CUI_CHAT | COMSATS University Islamabad Social Platform">
<meta name="twitter:description" content="Connect COMSATS students and faculty across campuses through a secure, verified academic social platform.">
<meta name="twitter:image" content="{{ asset('asset/cuichat-logo.png') }}">
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<script>
tailwind.config = {
  darkMode:"class",
  theme:{
    extend:{
      colors:{
        "primary":"#00113a","primary-container":"#002366","on-primary-container":"#758dd5",
        "secondary":"#8333c6","secondary-container":"#b96cfd","surface":"#faf8ff",
        "surface-container":"#efedf3","surface-container-low":"#f4f3f9",
        "surface-container-lowest":"#ffffff","on-surface":"#1a1b20","outline":"#757682",
        "outline-variant":"#c5c6d2","background":"#faf8ff"
      },
      fontFamily:{"manrope":["Manrope","sans-serif"]}
    }
  }
}
</script>
<style>
*{box-sizing:border-box;margin:0;padding:0;}
body{font-family:"Manrope",sans-serif;overflow-x:hidden;background:#faf8ff;}
.material-symbols-outlined{font-variation-settings:"FILL" 0,"wght" 400,"GRAD" 0,"opsz" 24;}
/* ── Existing shared styles (non-hero) ── */
.glass-card{background:rgba(255,255,255,0.75);backdrop-filter:blur(16px);border:1px solid rgba(255,255,255,0.4);}
.glass-dark{background:rgba(0,17,58,0.7);backdrop-filter:blur(16px);border:1px solid rgba(255,255,255,0.1);}
.accent-gradient{background:linear-gradient(135deg,#002366 0%,#8333c6 100%);}
.accent-gradient-text{background:linear-gradient(135deg,#002366,#8333c6);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
.glow-blue{box-shadow:0 0 30px rgba(0,35,102,0.2),0 0 60px rgba(0,35,102,0.1);}
.glow-purple{box-shadow:0 0 30px rgba(131,51,198,0.2),0 0 60px rgba(131,51,198,0.1);}
.glow-card{transition:all 0.3s ease;border:1px solid rgba(0,35,102,0.1);}
.glow-card:hover{transform:translateY(-6px);box-shadow:0 20px 60px rgba(0,35,102,0.15),0 0 0 1px rgba(131,51,198,0.2);border-color:rgba(131,51,198,0.3);}
.fade-in-up{opacity:0;transform:translateY(30px);transition:opacity 0.6s ease,transform 0.6s ease;}
.fade-in-up.visible{opacity:1;transform:translateY(0);}
/* ── Dropdown: visibility-based so hover bridge works ── */
.nav-dropdown{
  opacity:0;
  visibility:hidden;
  pointer-events:none;
  position:absolute;
  top:100%;          /* flush to bottom of trigger — no gap */
  left:50%;
  transform:translateX(-50%) translateY(4px);
  min-width:220px;
  z-index:100;
  transition:opacity 0.18s ease, transform 0.18s ease, visibility 0s linear 0.18s;
}
/* Invisible hover bridge fills the gap between trigger and dropdown */
.nav-item::after{
  content:'';
  position:absolute;
  bottom:-10px;
  left:0;
  right:0;
  height:10px;
}
.nav-item:hover .nav-dropdown,
.nav-item:focus-within .nav-dropdown{
  opacity:1;
  visibility:visible;
  pointer-events:auto;
  transform:translateX(-50%) translateY(0);
  transition:opacity 0.18s ease, transform 0.18s ease, visibility 0s linear 0s;
}
.mobile-menu{display:none;flex-direction:column;}
.mobile-menu.open{display:flex;}
.accordion-content{max-height:0;overflow:hidden;transition:max-height 0.4s ease,padding 0.3s ease;}
.accordion-content.open{max-height:600px;}
.accordion-icon{transition:transform 0.3s ease;}
.accordion-item.open .accordion-icon{transform:rotate(180deg);}
#particles-canvas{position:absolute;top:0;left:0;width:100%;height:100%;pointer-events:none;}
.comparison-card{background:white;border-radius:20px;border:1px solid rgba(0,35,102,0.08);transition:all 0.3s ease;overflow:hidden;}
.comparison-card:hover{transform:translateY(-4px);box-shadow:0 20px 50px rgba(0,35,102,0.12);border-color:rgba(131,51,198,0.25);}
.roadmap-card{background:linear-gradient(135deg,rgba(0,17,58,0.95),rgba(131,51,198,0.8));border-radius:20px;border:1px solid rgba(255,255,255,0.1);transition:all 0.3s ease;position:relative;overflow:hidden;}
.roadmap-card::before{content:"";position:absolute;top:-50%;left:-50%;width:200%;height:200%;background:radial-gradient(circle,rgba(255,255,255,0.03) 0%,transparent 60%);pointer-events:none;}
.roadmap-card:hover{transform:translateY(-6px);box-shadow:0 20px 60px rgba(131,51,198,0.3);}
.faq-item{border:1px solid rgba(0,35,102,0.1);border-radius:16px;overflow:hidden;transition:border-color 0.3s ease;}
.faq-item.open{border-color:rgba(131,51,198,0.3);box-shadow:0 4px 20px rgba(131,51,198,0.1);}
.category-pill{padding:6px 16px;border-radius:999px;font-size:13px;font-weight:600;cursor:pointer;transition:all 0.2s ease;border:1px solid rgba(0,35,102,0.15);}
.category-pill.active{background:linear-gradient(135deg,#002366,#8333c6);color:white;border-color:transparent;}
.category-pill:not(.active):hover{background:rgba(0,35,102,0.05);}
html{scroll-behavior:smooth;}

/* ══════════════════════════════════════════
   PREMIUM NAVBAR — dark glassmorphism
══════════════════════════════════════════ */
.premium-navbar{
  background:rgba(0,17,58,0.72);
  backdrop-filter:blur(20px);
  -webkit-backdrop-filter:blur(20px);
  border-bottom:1px solid rgba(255,255,255,0.10);
  box-shadow:0 4px 32px rgba(0,0,0,0.18);
}
.premium-navbar .pnav-link{
  position:relative;
  color:rgba(255,255,255,0.78);
  font-size:0.875rem;
  font-weight:600;
  padding:8px 12px;
  border-radius:8px;
  text-decoration:none;
  transition:color 0.25s ease, background 0.25s ease;
}
.premium-navbar .pnav-link::after{
  content:'';
  position:absolute;
  bottom:-2px;
  left:12px;
  right:12px;
  height:2px;
  background:#00fbfb;
  border-radius:2px;
  transform:scaleX(0);
  transition:transform 0.3s ease;
}
.premium-navbar .pnav-link:hover{color:#fff;}
.premium-navbar .pnav-link:hover::after{transform:scaleX(1);}
.premium-navbar .pnav-link.active-link{color:#00fbfb;}
.premium-navbar .pnav-link.active-link::after{transform:scaleX(1);}
/* Explore button */
.premium-navbar .pnav-explore{
  background:linear-gradient(135deg,#8333c6 0%,#435b9f 100%);
  color:#fff;
  padding:9px 22px;
  border-radius:9999px;
  font-size:0.8125rem;
  font-weight:700;
  text-decoration:none;
  box-shadow:0 0 18px rgba(131,51,198,0.45),inset 0 1px 1px rgba(255,255,255,0.25);
  transition:all 0.35s cubic-bezier(0.4,0,0.2,1);
  white-space:nowrap;
}
.premium-navbar .pnav-explore:hover{
  box-shadow:0 0 28px rgba(131,51,198,0.65),inset 0 1px 1px rgba(255,255,255,0.35);
  transform:translateY(-2px) scale(1.03);
  color:#fff;
}
/* Dropdown inside premium navbar */
.premium-navbar .nav-dropdown{
  background:rgba(0,17,58,0.92);
  backdrop-filter:blur(20px);
  -webkit-backdrop-filter:blur(20px);
  border:1px solid rgba(255,255,255,0.12);
  box-shadow:0 16px 48px rgba(0,0,0,0.35);
}
.premium-navbar .nav-dropdown a{color:rgba(255,255,255,0.8);}
.premium-navbar .nav-dropdown a:hover{background:rgba(255,255,255,0.07);color:#fff;}
.premium-navbar .nav-dropdown .text-primary{color:#b3c5ff !important;}
.premium-navbar .nav-dropdown .text-secondary{color:#dfb7ff !important;}
.premium-navbar .nav-dropdown .text-slate-500{color:rgba(255,255,255,0.45) !important;}
/* Mobile menu inside premium navbar */
.premium-navbar .mobile-menu{
  background:rgba(0,12,40,0.97);
  backdrop-filter:blur(20px);
  -webkit-backdrop-filter:blur(20px);
  border-top:1px solid rgba(255,255,255,0.08);
}
.premium-navbar .mobile-menu a,
.premium-navbar .mobile-menu button{color:rgba(255,255,255,0.82);}
.premium-navbar .mobile-menu a:hover{color:#fff;}
.premium-navbar .mobile-menu .border-b{border-color:rgba(255,255,255,0.08) !important;}
.premium-navbar .mobile-menu .border-slate-100{border-color:rgba(255,255,255,0.08) !important;}
.premium-navbar .mobile-menu .text-blue-900{color:#fff !important;}
.premium-navbar .mobile-menu .text-slate-700,.premium-navbar .mobile-menu .text-slate-600{color:rgba(255,255,255,0.75) !important;}
.premium-navbar .mobile-menu .accordion-content a{color:rgba(255,255,255,0.65);}

/* ══════════════════════════════════════════
   PREMIUM HERO — dark aurora section
══════════════════════════════════════════ */
.premium-hero{
  background-color:#00113a;
  background-image:
    radial-gradient(at 0% 0%,   #00113a 0px, transparent 50%),
    radial-gradient(at 50% 0%,  rgba(131,51,198,0.22) 0px, transparent 55%),
    radial-gradient(at 100% 0%, #002366 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(185,108,253,0.16) 0px, transparent 50%),
    radial-gradient(at 0% 100%,  rgba(0,251,251,0.10) 0px, transparent 50%);
  position:relative;
  overflow:hidden;
}
/* Star/dot texture */
.premium-hero::before{
  content:'';
  position:absolute;
  inset:0;
  background-image:radial-gradient(circle,rgba(255,255,255,0.10) 1px,transparent 1px);
  background-size:48px 48px;
  opacity:0.28;
  pointer-events:none;
}
/* Ambient glow blobs */
.ph-blob-purple{
  position:absolute;
  top:-8%;right:8%;
  width:52vw;height:52vw;
  background:rgba(131,51,198,0.18);
  border-radius:50%;
  filter:blur(120px);
  pointer-events:none;
  animation:phPulse 8s ease-in-out infinite;
}
.ph-blob-cyan{
  position:absolute;
  bottom:0;left:-4%;
  width:42vw;height:42vw;
  background:rgba(0,251,251,0.08);
  border-radius:50%;
  filter:blur(150px);
  pointer-events:none;
}
@keyframes phPulse{0%,100%{opacity:0.7;}50%{opacity:1;}}

/* Glow pill badge */
.hero-glow-pill{
  background:rgba(0,251,251,0.10);
  border:1px solid rgba(0,251,251,0.30);
  box-shadow:0 0 14px rgba(0,251,251,0.14);
  color:#00fbfb;
  text-shadow:0 0 8px rgba(0,251,251,0.5);
}
/* Gradient heading span */
.hero-gradient-text{
  background:linear-gradient(90deg,#00fbfb 0%,#dfb7ff 50%,#8333c6 100%);
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
  background-clip:text;
}
/* Primary CTA button */
.hero-btn-primary{
  background:linear-gradient(135deg,#8333c6 0%,#435b9f 100%);
  box-shadow:0 0 22px rgba(131,51,198,0.42),inset 0 1px 1px rgba(255,255,255,0.28);
  color:#fff;
  border:none;
  transition:all 0.35s cubic-bezier(0.4,0,0.2,1);
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  gap:8px;
}
.hero-btn-primary:hover{
  box-shadow:0 0 34px rgba(131,51,198,0.62),inset 0 1px 1px rgba(255,255,255,0.38);
  transform:translateY(-2px) scale(1.02);
  color:#fff;
}
.hero-btn-primary:active{transform:scale(0.97);}
/* Secondary CTA button */
.hero-btn-secondary{
  background:rgba(255,255,255,0.07);
  backdrop-filter:blur(16px);
  -webkit-backdrop-filter:blur(16px);
  border:1px solid rgba(255,255,255,0.18);
  color:#fff;
  transition:all 0.3s ease;
  text-decoration:none;
  display:inline-flex;
  align-items:center;
  gap:8px;
}
.hero-btn-secondary:hover{background:rgba(255,255,255,0.13);color:#fff;transform:translateY(-1px);}
/* Trust chips */
.hero-chip{
  background:rgba(255,255,255,0.07);
  backdrop-filter:blur(16px);
  -webkit-backdrop-filter:blur(16px);
  border:1px solid rgba(255,255,255,0.14);
  box-shadow:0 4px 16px rgba(0,0,0,0.15);
  color:rgba(255,255,255,0.90);
  transition:all 0.3s ease;
}
.hero-chip:hover{
  background:rgba(0,251,251,0.10);
  border-color:rgba(0,251,251,0.30);
  box-shadow:0 0 14px rgba(0,251,251,0.18);
  transform:translateY(-2px);
}
/* Glass floating cards */
.hero-glass-card{
  background:rgba(255,255,255,0.08);
  backdrop-filter:blur(24px);
  -webkit-backdrop-filter:blur(24px);
  border:1px solid rgba(255,255,255,0.15);
  box-shadow:0 8px 32px rgba(0,0,0,0.22);
  border-radius:16px;
  padding:12px 16px;
  white-space:nowrap;
  color:#fff;
  font-size:13px;
  font-weight:600;
}
/* ══════════════════════════════════════════
   HERO FLOATING BADGES (HFB)
══════════════════════════════════════════ */
.hfb-badge {
  width: 40px;
  height: 40px;
  padding: 5px;
  overflow: hidden;
  display: inline-flex;
  align-items: center;
  flex-wrap: nowrap;
  gap: 10px;
  background: rgba(255,255,255,0.08);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(255,255,255,0.15);
  box-shadow: 0 8px 32px rgba(0,0,0,0.22);
  border-radius: 999px;
  transition: width .35s ease, height .35s ease,
              padding .35s ease, transform .35s ease,
              box-shadow .35s ease, background .35s ease,
              border-color .35s ease;
  position: absolute;
  white-space: nowrap;
  cursor: default;
  color: #fff;
  font-size: 13px;
  font-weight: 600;
  font-family: 'Manrope', sans-serif;
}
.hfb-badge:hover,
.hfb-badge:focus-visible,
.hfb-badge.hfb-expanded {
  width: auto;
  max-width: 220px;
  height: 40px;
  padding: 5px 14px 5px 5px;
  background: rgba(255,255,255,0.14);
  border-color: rgba(255,255,255,0.28);
  box-shadow: 0 12px 40px rgba(0,0,0,0.35),
              0 0 20px rgba(131,51,198,0.25);
  transform: translateY(-3px);
  outline: none;
  z-index: 50;
}
/* Right-side badges (flex-direction:row-reverse) expand leftward */
.hfb-badge[style*="row-reverse"]:hover,
.hfb-badge[style*="row-reverse"]:focus-visible,
.hfb-badge[style*="row-reverse"].hfb-expanded {
  padding: 5px 5px 5px 14px;
}
.hfb-icon {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.hfb-icon .material-symbols-outlined {
  font-size: 17px;
  line-height: 1;
}
.hfb-label {
  opacity: 0;
  transform: translateX(-8px);
  transition: opacity .3s ease .05s, transform .3s ease .05s;
  pointer-events: none;
  white-space: nowrap;
  flex-shrink: 0;
}
.hfb-badge:hover .hfb-label,
.hfb-badge:focus-visible .hfb-label,
.hfb-badge.hfb-expanded .hfb-label {
  opacity: 1;
  transform: translateX(0);
  pointer-events: auto;
}
/* Right-side badges: label slides from right */
.hfb-badge[style*="row-reverse"] .hfb-label {
  transform: translateX(8px);
}
.hfb-badge[style*="row-reverse"]:hover .hfb-label,
.hfb-badge[style*="row-reverse"]:focus-visible .hfb-label,
.hfb-badge[style*="row-reverse"].hfb-expanded .hfb-label {
  transform: translateX(0);
}
/* Floating animation */
.ph-float{animation:phFloat 6s ease-in-out infinite;}
.ph-float-2{animation:phFloat 7s ease-in-out infinite;animation-delay:1.5s;}
.ph-float-3{animation:phFloat 5.5s ease-in-out infinite;animation-delay:0.8s;}
.ph-float-4{animation:phFloat 8s ease-in-out infinite;animation-delay:2.2s;}
@keyframes phFloat{0%,100%{transform:translateY(0);}50%{transform:translateY(-14px);}}
/* Mockup image float */
.ph-mockup-float{animation:phMockupFloat 7s ease-in-out infinite;}
@keyframes phMockupFloat{0%,100%{transform:translateY(0);}50%{transform:translateY(-10px);}}

/* Reduced motion */
@media(prefers-reduced-motion:reduce){
  .ph-float,.ph-float-2,.ph-float-3,.ph-float-4,.ph-mockup-float,.ph-blob-purple{animation:none;}
  .hfb-badge{transition:none;}
  .hfb-label{transition:none;}
  #particles-canvas{display:none;}
  .fade-in-up{opacity:1;transform:none;}
}
/* Mobile hero adjustments */
@media(max-width:768px){
  .hero-glass-card{display:none;}
  .hfb-badge{display:none;}
  .ph-mockup-float{animation:none;}
}
@media(max-width:640px){
  .hero-btn-primary,.hero-btn-secondary{width:100%;justify-content:center;}
}

/* ══════════════════════════════════════════
   WHAT IS CUICHAT — Premium Dark Section
══════════════════════════════════════════ */
.cuichat-about-section {
  background: radial-gradient(circle at 20% 30%, #002366 0%, #4b0082 100%);
  position: relative;
  overflow: hidden;
}
.cuichat-about-orb {
  position: absolute;
  filter: blur(80px);
  border-radius: 9999px;
  pointer-events: none;
  z-index: 0;
}
.cuichat-about-badge {
  display: inline-flex;
  align-items: center;
  padding: 6px 16px;
  border-radius: 9999px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.10);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  color: #00dddd;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}
.cuichat-about-card {
  background: rgba(255,255,255,0.03);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255,255,255,0.10);
  border-radius: 16px;
  transition: transform 0.5s ease, border-color 0.3s ease, box-shadow 0.3s ease;
  position: relative;
  overflow: hidden;
}
.cuichat-about-card:hover {
  transform: translateY(-8px);
  border-color: rgba(0,251,251,0.30);
  box-shadow: 0 0 30px rgba(131,51,198,0.20);
}
/* Shimmer sweep on hover */
.cuichat-about-card::after {
  content: '';
  position: absolute;
  top: -50%; left: -50%;
  width: 200%; height: 200%;
  background: linear-gradient(45deg, transparent, rgba(255,255,255,0.05), transparent);
  transform: rotate(45deg) translateX(-100%);
  transition: transform 0.7s ease;
  pointer-events: none;
}
.cuichat-about-card:hover::after {
  transform: rotate(45deg) translateX(100%);
}
.cuichat-about-icon-wrap {
  width: 48px; height: 48px;
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
  transition: transform 0.3s ease;
}
.cuichat-about-card:hover .cuichat-about-icon-wrap {
  transform: scale(1.12);
}
/* Reveal animation */
.cuichat-about-reveal {
  opacity: 0;
  transform: translateY(32px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.cuichat-about-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
/* Image card */
.cuichat-about-img-card {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.10);
}
.cuichat-about-img-card img {
  width: 100%; height: 420px;
  object-fit: cover;
  border-radius: 12px;
  opacity: 0.80;
  display: block;
}
.cuichat-about-img-overlay {
  position: absolute; inset: 0;
  background: linear-gradient(to top, rgba(0,17,58,0.85) 0%, transparent 55%);
  border-radius: 12px;
  display: flex; align-items: flex-end;
  padding: 32px;
}
/* Gradient text for heading */
.cuichat-about-gradient-text {
  background: linear-gradient(90deg, #00dddd 0%, #dfb7ff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
/* Star particles */
.cuichat-about-star {
  position: absolute;
  width: 3px; height: 3px;
  background: #fff;
  border-radius: 50%;
  opacity: 0.18;
  pointer-events: none;
}
@media(prefers-reduced-motion:reduce){
  .cuichat-about-reveal { opacity:1; transform:none; transition:none; }
  .cuichat-about-card { transition:none; }
  .cuichat-about-card::after { display:none; }
}
@media(max-width:768px){
  .cuichat-about-img-card img { height: 260px; }
}

/* ══════════════════════════════════════════
   WHY CUICHAT — Premium Dark Comparison
══════════════════════════════════════════ */
.cuichat-comparison-section {
  background:
    radial-gradient(at 0% 0%,   #00113a 0%, transparent 55%),
    radial-gradient(at 100% 0%, #002366 0%, transparent 55%),
    radial-gradient(at 100% 100%, #163152 0%, transparent 55%),
    radial-gradient(at 0% 100%,  #001717 0%, transparent 55%);
  background-color: #00113a;
  position: relative;
  overflow: hidden;
}
.cuichat-comparison-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(circle, rgba(255,255,255,0.06) 1px, transparent 1px);
  background-size: 48px 48px;
  opacity: 0.18;
  pointer-events: none;
}
.cuichat-comparison-badge {
  display: inline-block;
  padding: 5px 16px;
  border-radius: 9999px;
  background: rgba(0,46,46,0.50);
  border: 1px solid rgba(0,221,221,0.30);
  box-shadow: 0 0 10px rgba(0,221,221,0.20);
  color: #00dddd;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}
.cuichat-comparison-card {
  background: rgba(0,35,102,0.40);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(224,231,255,0.10);
  border-radius: 16px;
  transition: transform 0.35s ease, border-color 0.3s ease, box-shadow 0.3s ease;
  overflow: hidden;
}
.cuichat-comparison-card:hover {
  transform: translateY(-6px);
  border-color: rgba(0,221,221,0.45);
  box-shadow: 0 0 24px rgba(0,221,221,0.18), 0 16px 40px rgba(0,0,0,0.35);
}
.cuichat-compare-icon {
  width: 44px; height: 44px;
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
  background: linear-gradient(135deg, #002366 0%, #8333c6 100%);
  box-shadow: 0 0 16px rgba(131,51,198,0.30);
  transition: box-shadow 0.3s ease, transform 0.3s ease;
}
.cuichat-comparison-card:hover .cuichat-compare-icon {
  box-shadow: 0 0 24px rgba(0,221,221,0.35);
  transform: scale(1.08);
}
.cuichat-compare-whatsapp {
  background: rgba(239,68,68,0.10);
  border: 1px solid rgba(239,68,68,0.22);
  border-radius: 10px;
  padding: 10px 12px;
}
.cuichat-compare-cuichat {
  background: rgba(0,46,46,0.45);
  border: 1px solid rgba(0,221,221,0.28);
  border-radius: 10px;
  padding: 10px 12px;
}
.cuichat-compare-point {
  display: flex;
  align-items: flex-start;
  gap: 6px;
  margin-bottom: 4px;
  font-size: 12px;
  line-height: 1.5;
}
/* Staggered reveal */
.cuichat-comparison-reveal {
  opacity: 0;
  transform: translateY(28px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.cuichat-comparison-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
@media(prefers-reduced-motion:reduce){
  .cuichat-comparison-reveal { opacity:1; transform:none; transition:none; }
  .cuichat-comparison-card { transition:none; }
}

/* ══════════════════════════════════════════
   CORE PLATFORM FEATURES — Premium Dark
══════════════════════════════════════════ */
.cuichat-features-section {
  background:
    radial-gradient(circle at 20% 30%, #00113a 0%, transparent 55%),
    radial-gradient(circle at 80% 70%, #435b9f 0%, transparent 55%),
    radial-gradient(circle at 50% 50%, #002366 0%, #00113a 100%);
  background-color: #00113a;
  position: relative;
  overflow: hidden;
}
.cuichat-features-glow-blob {
  position: absolute;
  width: 400px; height: 400px;
  border-radius: 50%;
  filter: blur(100px);
  pointer-events: none;
  z-index: 0;
}
.cuichat-features-badge {
  display: inline-flex;
  align-items: center;
  padding: 6px 20px;
  border-radius: 9999px;
  background: rgba(255,255,255,0.05);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(0,251,251,0.30);
  box-shadow: 0 0 20px rgba(0,251,251,0.20);
  color: #00fbfb;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}
.cuichat-features-underline {
  height: 4px;
  width: 80px;
  background: linear-gradient(90deg, #00fbfb, transparent);
  border-radius: 2px;
  margin: 10px auto 0;
}
.cuichat-feature-card {
  background: rgba(0,17,58,0.60);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(0,251,251,0.10);
  border-radius: 16px;
  transition: transform 0.4s cubic-bezier(0.4,0,0.2,1),
              border-color 0.4s ease,
              box-shadow 0.4s ease;
  position: relative;
  overflow: hidden;
}
.cuichat-feature-card:hover {
  transform: translateY(-10px);
  border-color: rgba(0,251,251,0.40);
  box-shadow: 0 0 30px rgba(0,251,251,0.15), 0 0 60px rgba(131,51,198,0.10);
}
.cuichat-feature-icon {
  width: 56px; height: 56px;
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
  background: linear-gradient(135deg, #00113a 0%, #8333c6 100%);
  box-shadow: 0 8px 24px rgba(0,17,58,0.40);
  transition: box-shadow 0.3s ease, transform 0.3s ease;
  margin-bottom: 20px;
}
.cuichat-feature-card:hover .cuichat-feature-icon {
  box-shadow: 0 0 20px rgba(0,251,251,0.30), 0 8px 24px rgba(0,17,58,0.40);
  transform: scale(1.08);
}
.cuichat-feature-watermark {
  position: absolute;
  right: -20px; bottom: -20px;
  font-size: 120px !important;
  opacity: 0.03;
  transform: rotate(-15deg);
  pointer-events: none;
  transition: opacity 0.4s ease;
}
.cuichat-feature-card:hover .cuichat-feature-watermark {
  opacity: 0.06;
}
/* Staggered reveal */
.cuichat-features-reveal {
  opacity: 0;
  transform: translateY(28px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.cuichat-features-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
@media(prefers-reduced-motion:reduce){
  .cuichat-features-reveal { opacity:1; transform:none; transition:none; }
  .cuichat-feature-card { transition:none; }
  .cuichat-feature-card:hover { transform:none; }
}

/* ══════════════════════════════════════════
   UNIFIED COMSATS NETWORK — Premium Map v2
══════════════════════════════════════════ */
.cuichat-network-section {
  background-color: #020b2d;
  background-image:
    radial-gradient(at 0% 0%,   rgba(131,51,198,0.15) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(0,221,221,0.10)  0px, transparent 50%),
    radial-gradient(at 50% 100%,rgba(0,35,102,0.30)   0px, transparent 50%);
  position: relative;
  overflow: hidden;
}
.cuichat-network-grid {
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.05) 1px, transparent 1px);
  background-size: 40px 40px;
  opacity: 0.30;
  pointer-events: none;
}
.cuichat-network-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 20px;
  border-radius: 9999px;
  background: rgba(255,255,255,0.03);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255,255,255,0.10);
  color: #00dddd;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}
.cuichat-network-badge-dot {
  width: 8px; height: 8px;
  border-radius: 50%;
  background: #00dddd;
  box-shadow: 0 0 8px #00dddd;
  flex-shrink: 0;
}
/* ── Hub ── */
.cuichat-network-hub {
  background: rgba(255,255,255,0.03);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(0,221,221,0.40);
  border-radius: 16px;
  box-shadow: 0 0 50px rgba(0,221,221,0.20);
  transition: transform 0.5s ease, box-shadow 0.5s ease;
  position: relative; z-index: 30;
}
.cuichat-network-hub:hover {
  transform: scale(1.06);
  box-shadow: 0 0 80px rgba(0,221,221,0.40), 0 0 120px rgba(131,51,198,0.20);
}
.cuichat-network-hub-icon {
  width: 96px; height: 96px;
  border-radius: 50%;
  background: rgba(0,35,102,0.50);
  border: 2px solid rgba(0,221,221,0.30);
  box-shadow: 0 0 30px rgba(0,221,221,0.10);
  display: flex; align-items: center; justify-content: center;
  margin: 0 auto 16px;
  transition: box-shadow 0.4s ease;
}
.cuichat-network-hub:hover .cuichat-network-hub-icon {
  box-shadow: 0 0 50px rgba(0,221,221,0.40);
  animation: hubIconPulse 1.2s ease-in-out infinite;
}
@keyframes hubIconPulse {
  0%,100% { transform: scale(1); }
  50%      { transform: scale(1.08); }
}
/* ── Campus nodes ── */
.cuichat-campus-node {
  background: rgba(255,255,255,0.03);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255,255,255,0.10);
  border-radius: 9999px;
  padding: 10px 24px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #fff;
  font-weight: 700;
  font-size: 15px;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  cursor: default;
  white-space: nowrap;
  transition: border-color 0.3s ease, background 0.3s ease,
              box-shadow 0.3s ease, transform 0.3s ease;
}
.cuichat-campus-node:hover {
  border-color: rgba(0,221,221,0.60);
  background: rgba(0,221,221,0.08);
  box-shadow: 0 0 20px rgba(0,221,221,0.25), 0 8px 24px rgba(0,0,0,0.30);
  transform: translateY(-10px) scale(1.08) !important; /* override float anim */
}
/* ── Floating animations (7 variants) ── */
@keyframes cnFloat1 { 0%,100%{transform:translateY(0);}   50%{transform:translateY(-7px);} }
@keyframes cnFloat2 { 0%,100%{transform:translateY(-4px);}50%{transform:translateY(5px);}  }
@keyframes cnFloat3 { 0%,100%{transform:translateY(3px);} 50%{transform:translateY(-6px);} }
@keyframes cnFloat4 { 0%,100%{transform:translateY(-2px);}50%{transform:translateY(6px);}  }
@keyframes cnFloat5 { 0%,100%{transform:translateY(0);}   50%{transform:translateY(-8px);} }
@keyframes cnFloat6 { 0%,100%{transform:translateY(-5px);}50%{transform:translateY(4px);}  }
@keyframes cnFloat7 { 0%,100%{transform:translateY(2px);} 50%{transform:translateY(-5px);} }
.cn-float-1 { animation: cnFloat1 5.0s ease-in-out infinite; }
.cn-float-2 { animation: cnFloat2 5.8s ease-in-out infinite; animation-delay:0.7s; }
.cn-float-3 { animation: cnFloat3 4.6s ease-in-out infinite; animation-delay:1.3s; }
.cn-float-4 { animation: cnFloat4 6.2s ease-in-out infinite; animation-delay:0.4s; }
.cn-float-5 { animation: cnFloat5 5.4s ease-in-out infinite; animation-delay:1.8s; }
.cn-float-6 { animation: cnFloat6 4.9s ease-in-out infinite; animation-delay:2.2s; }
.cn-float-7 { animation: cnFloat7 5.6s ease-in-out infinite; animation-delay:0.9s; }
/* ── Dot colors ── */
.cuichat-campus-dot-cyan {
  width: 8px; height: 8px; border-radius: 50%;
  background: #00dddd; flex-shrink: 0;
  box-shadow: 0 0 6px #00dddd;
}
.cuichat-campus-dot-purple {
  width: 8px; height: 8px; border-radius: 50%;
  background: #b96cfd; flex-shrink: 0;
  box-shadow: 0 0 6px #b96cfd;
}
/* ── SVG lines ── */
.cuichat-network-svg {
  pointer-events: none;
  overflow: visible;
}
.cuichat-network-line {
  stroke-width: 2;
  stroke: url(#cn-grad-v2);
  fill: none;
  opacity: 0.55;
  transition: opacity 0.3s ease, stroke-width 0.3s ease;
}
.cuichat-network-line.active {
  opacity: 1;
  stroke-width: 3.5;
  stroke-dasharray: 8 10;
  animation: lineWave 1.2s linear infinite;
  filter: url(#cn-glow);
}
@keyframes lineWave {
  from { stroke-dashoffset: 0; }
  to   { stroke-dashoffset: -36; }
}
/* ── Staggered reveal ── */
.cuichat-network-reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.cuichat-network-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
/* ── Network map container ── */
.cuichat-network-map {
  position: relative;
  width: 100%;
  height: 600px;
}
@media(max-width:1024px){
  .cuichat-network-map { height: 520px; }
}
@media(prefers-reduced-motion:reduce){
  .cuichat-network-reveal { opacity:1; transform:none; transition:none; }
  .cuichat-network-hub,
  .cuichat-campus-node { transition:none; }
  .cn-float-1,.cn-float-2,.cn-float-3,.cn-float-4,
  .cn-float-5,.cn-float-6,.cn-float-7 { animation:none; }
  .cuichat-network-line.active { animation:none; }
}

/* ══════════════════════════════════════════
   HOW IT WORKS — Premium Dark Timeline
══════════════════════════════════════════ */
.cuichat-how-section {
  background-color: #00113a;
  background-image:
    radial-gradient(at 0% 50%,   rgba(131,51,198,0.12) 0px, transparent 55%),
    radial-gradient(at 100% 50%, rgba(0,221,221,0.08)  0px, transparent 55%),
    radial-gradient(at 50% 0%,   rgba(0,35,102,0.25)   0px, transparent 55%);
  position: relative;
  overflow: hidden;
}
.cuichat-how-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 44px 44px;
  opacity: 0.25;
  pointer-events: none;
}
.cuichat-how-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 5px 18px;
  border-radius: 9999px;
  background: rgba(0,46,46,0.45);
  border: 1px solid rgba(0,221,221,0.28);
  box-shadow: 0 0 10px rgba(0,221,221,0.15);
  color: #00dddd;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}
/* Timeline wrapper */
.cuichat-how-timeline {
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 0;
}
/* Connecting line */
.cuichat-how-line {
  position: absolute;
  top: 32px; /* center of 64px node */
  left: 32px;
  right: 32px;
  height: 2px;
  background: linear-gradient(90deg, #00dddd 0%, #8333c6 50%, #00dddd 100%);
  opacity: 0.30;
  z-index: 0;
  transform-origin: left center;
  transition: opacity 0.4s ease;
}
.cuichat-how-timeline:hover .cuichat-how-line {
  opacity: 0.55;
}
/* Individual step */
.cuichat-how-step {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  position: relative;
  z-index: 1;
  padding: 0 8px;
  cursor: default;
}
/* Number node */
.cuichat-how-node {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  font-weight: 900;
  color: #fff;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  background: rgba(0,17,58,0.80);
  border: 2px solid rgba(0,221,221,0.35);
  box-shadow: 0 0 18px rgba(0,221,221,0.15), inset 0 0 12px rgba(0,35,102,0.40);
  transition: transform 0.35s ease, box-shadow 0.35s ease, border-color 0.35s ease, background 0.35s ease;
  margin-bottom: 16px;
  position: relative;
}
/* Pulse ring on node */
.cuichat-how-node::after {
  content: '';
  position: absolute;
  inset: -6px;
  border-radius: 50%;
  border: 1px solid rgba(0,221,221,0.20);
  transition: border-color 0.35s ease, opacity 0.35s ease;
  opacity: 0;
}
.cuichat-how-step:hover .cuichat-how-node {
  transform: scale(1.12) translateY(-4px);
  background: linear-gradient(135deg, #002366 0%, #8333c6 100%);
  border-color: rgba(0,221,221,0.70);
  box-shadow: 0 0 32px rgba(0,221,221,0.35), 0 0 60px rgba(131,51,198,0.20), inset 0 0 12px rgba(0,35,102,0.40);
}
.cuichat-how-step:hover .cuichat-how-node::after {
  opacity: 1;
  border-color: rgba(0,221,221,0.45);
}
/* Step title */
.cuichat-how-step-title {
  color: #fff;
  font-weight: 700;
  font-size: 14px;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  margin-bottom: 6px;
  transition: color 0.3s ease;
}
.cuichat-how-step:hover .cuichat-how-step-title {
  color: #00dddd;
}
/* Step description */
.cuichat-how-step-desc {
  color: rgba(212,227,255,0.65);
  font-size: 12px;
  font-family: 'Manrope', sans-serif;
  line-height: 1.5;
  max-width: 110px;
  transition: color 0.3s ease;
}
.cuichat-how-step:hover .cuichat-how-step-desc {
  color: rgba(212,227,255,0.90);
}
/* Connector dot between steps */
.cuichat-how-step-dot {
  position: absolute;
  top: 30px;
  right: -4px;
  width: 8px; height: 8px;
  border-radius: 50%;
  background: #00dddd;
  box-shadow: 0 0 8px #00dddd;
  opacity: 0.50;
  z-index: 2;
}
/* Staggered reveal */
.cuichat-how-reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.cuichat-how-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
/* Mobile vertical timeline */
@media(max-width:767px){
  .cuichat-how-timeline {
    flex-direction: column;
    align-items: flex-start;
    gap: 0;
  }
  .cuichat-how-line {
    top: 32px;
    left: 31px;
    right: auto;
    width: 2px;
    height: calc(100% - 64px);
    background: linear-gradient(180deg, #00dddd 0%, #8333c6 50%, #00dddd 100%);
  }
  .cuichat-how-step {
    flex-direction: row;
    text-align: left;
    align-items: flex-start;
    gap: 20px;
    padding: 0 0 32px 0;
    width: 100%;
  }
  .cuichat-how-node {
    flex-shrink: 0;
    margin-bottom: 0;
  }
  .cuichat-how-step-dot { display: none; }
  .cuichat-how-step-desc { max-width: none; }
}
@media(prefers-reduced-motion:reduce){
  .cuichat-how-section *,
  .cuichat-how-section *::before,
  .cuichat-how-section *::after {
    animation: none !important;
    transition: none !important;
  }
  .cuichat-how-reveal { opacity:1; transform:none; }
}

/* ══════════════════════════════════════════
   CUICHAT LOGO — ROUNDED-SQUARE
   NOTE: logo file is a JPEG (no alpha channel).
   The white padding in the JPEG is cropped via scale(1.15)
   + overflow:hidden. filter:brightness boosts visibility
   on dark navbar/footer backgrounds.
══════════════════════════════════════════ */
.cuichat-logo-wrap {
  width: 54px; height: 54px;
  border-radius: 16px;
  overflow: hidden;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  background: rgba(255,255,255,0.10) !important;
  border: 1px solid rgba(34,211,238,0.35) !important;
  box-shadow: 0 0 18px rgba(34,211,238,0.28), 0 4px 16px rgba(0,0,0,0.25) !important;
  padding: 0 !important;
}
.cuichat-logo-img {
  width: 100%; height: 100%;
  display: block;
  object-fit: cover;
  object-position: center;
  border-radius: 0;
  padding: 0 !important;
  margin: 0 !important;
  transform: scale(1.15);
  filter: brightness(1.15) contrast(1.10) saturate(1.10);
}
/* Legacy alias */
.cuichat-logo-circle { display: none; }

/* ══════════════════════════════════════════
   WHATSAPP VS CUICHAT ROW
══════════════════════════════════════════ */
.cuichat-vs-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 28px;
  margin-top: 28px;
}
.cuichat-vs-brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  cursor: default;
}
.cuichat-vs-icon {
  width: 72px; height: 72px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  transition: transform 0.35s ease, box-shadow 0.35s ease;
}
.cuichat-vs-brand.whatsapp .cuichat-vs-icon {
  background: rgba(37,211,102,0.12);
  border: 1.5px solid rgba(37,211,102,0.35);
  box-shadow: 0 0 20px rgba(37,211,102,0.18);
}
.cuichat-vs-brand.whatsapp:hover .cuichat-vs-icon {
  transform: translateY(-5px) scale(1.08);
  box-shadow: 0 0 36px rgba(37,211,102,0.40);
  border-color: rgba(37,211,102,0.65);
}
.cuichat-vs-brand.cuichat .cuichat-vs-icon {
  background: rgba(0,221,221,0.10);
  border: 1.5px solid rgba(0,221,221,0.35);
  box-shadow: 0 0 20px rgba(0,221,221,0.18);
}
.cuichat-vs-brand.cuichat:hover .cuichat-vs-icon {
  transform: translateY(-5px) scale(1.08);
  box-shadow: 0 0 36px rgba(0,221,221,0.40), 0 0 60px rgba(131,51,198,0.20);
  border-color: rgba(0,221,221,0.65);
}
.cuichat-vs-label {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  font-family: 'Manrope', sans-serif;
}
.cuichat-vs-brand.whatsapp .cuichat-vs-label { color: rgba(37,211,102,0.85); }
.cuichat-vs-brand.cuichat  .cuichat-vs-label { color: rgba(0,221,221,0.85); }
.cuichat-vs-pill {
  width: 44px; height: 44px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px;
  font-weight: 900;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  color: #fff;
  background: linear-gradient(135deg, #002366 0%, #8333c6 100%);
  border: 1.5px solid rgba(255,255,255,0.18);
  box-shadow: 0 0 16px rgba(131,51,198,0.35);
  flex-shrink: 0;
  letter-spacing: 0.05em;
}
@media(max-width:480px){
  .cuichat-vs-row { gap: 16px; }
  .cuichat-vs-icon { width: 58px; height: 58px; }
  .cuichat-vs-pill { width: 36px; height: 36px; font-size: 11px; }
}

/* ══════════════════════════════════════════
   PLATFORM GOVERNANCE — Premium Dark
══════════════════════════════════════════ */
.platform-governance-section {
  background-color: #00113a;
  background-image:
    radial-gradient(at 0% 0%,   #00113a 0%, transparent 55%),
    radial-gradient(at 100% 0%, #002366 0%, transparent 55%),
    radial-gradient(at 100% 100%, #163152 0%, transparent 55%),
    radial-gradient(at 0% 100%, #001717 0%, transparent 55%);
  position: relative;
  overflow: hidden;
}
.platform-governance-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 40px 40px;
  opacity: 0.22;
  pointer-events: none;
}
/* Badge */
.governance-badge {
  display: inline-flex;
  align-items: center;
  align-self: flex-start;
  width: fit-content;
  white-space: nowrap;
  gap: 8px;
  padding: 5px 16px;
  border-radius: 9999px;
  background: rgba(0,46,46,0.45);
  border: 1px solid rgba(0,221,221,0.28);
  box-shadow: 0 0 10px rgba(0,221,221,0.15);
  color: #00dddd;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  margin-bottom: 20px;
}
/* Bullet rows */
.governance-bullet {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 16px;
  border-radius: 12px;
  background: rgba(0,35,102,0.30);
  border: 1px solid rgba(255,255,255,0.07);
  transition: transform 0.3s ease, border-color 0.3s ease, background 0.3s ease;
  cursor: default;
}
.governance-bullet:hover {
  transform: translateX(6px);
  border-color: rgba(0,221,221,0.30);
  background: rgba(0,35,102,0.50);
}
.governance-check {
  width: 36px; height: 36px;
  border-radius: 50%;
  background: rgba(0,46,46,0.60);
  border: 1px solid rgba(0,221,221,0.30);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
  transition: box-shadow 0.3s ease, transform 0.3s ease;
}
.governance-bullet:hover .governance-check {
  box-shadow: 0 0 14px rgba(0,221,221,0.35);
  transform: scale(1.08);
}
/* CTA button */
.governance-cta {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 28px;
  border-radius: 9999px;
  background: linear-gradient(45deg, #00113a, #8333c6);
  color: #fff;
  font-weight: 700;
  font-size: 14px;
  font-family: 'Manrope', sans-serif;
  text-decoration: none;
  border: none;
  cursor: pointer;
  box-shadow: 0 4px 20px rgba(131,51,198,0.30);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  position: relative;
  overflow: hidden;
}
.governance-cta::after {
  content: '';
  position: absolute;
  top: -50%; left: -60%;
  width: 40%; height: 200%;
  background: rgba(255,255,255,0.12);
  transform: skewX(-20deg);
  transition: left 0.5s ease;
}
.governance-cta:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 28px rgba(131,51,198,0.50);
  color: #fff;
}
.governance-cta:hover::after { left: 130%; }
/* Stat cards */
.governance-stat-card {
  background: rgba(0,35,102,0.40);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(224,231,255,0.10);
  border-radius: 16px;
  padding: 28px 20px;
  text-align: center;
  transition: transform 0.35s ease, border-color 0.35s ease, box-shadow 0.35s ease;
  position: relative;
  overflow: hidden;
}
.governance-stat-card:hover {
  transform: translateY(-6px);
  border-color: rgba(0,221,221,0.35);
  box-shadow: 0 0 24px rgba(0,221,221,0.15), 0 12px 32px rgba(0,0,0,0.30);
}
.governance-stat-number {
  font-size: 42px;
  font-weight: 900;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  line-height: 1;
  margin-bottom: 8px;
}
.governance-stat-label {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(212,227,255,0.60);
  font-family: 'Manrope', sans-serif;
}
/* Reveal */
.governance-reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.governance-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
.governance-reveal-right {
  opacity: 0;
  transform: translateX(24px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.governance-reveal-right.visible {
  opacity: 1;
  transform: translateX(0);
}
@media(prefers-reduced-motion:reduce){
  .platform-governance-section *,
  .platform-governance-section *::before,
  .platform-governance-section *::after {
    animation: none !important;
    transition: none !important;
  }
  .governance-reveal,
  .governance-reveal-right { opacity:1; transform:none; }
}

/* ══════════════════════════════════════════
   PREMIUM FEATURES ROADMAP — Dark Theme
══════════════════════════════════════════ */
.cuichat-roadmap-section {
  background-color: #020b2d;
  background-image:
    radial-gradient(at 0% 0%,   rgba(131,51,198,0.14) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(0,221,221,0.08)  0px, transparent 50%),
    radial-gradient(at 50% 100%,rgba(0,35,102,0.28)   0px, transparent 55%);
  position: relative;
  overflow: hidden;
}
.cuichat-roadmap-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 40px 40px;
  opacity: 0.20;
  pointer-events: none;
}

/* ══════════════════════════════════════════
   FAQ SECTION — Premium Dark
══════════════════════════════════════════ */
.faq-section {
  background-color: #020b2d;
  background-image:
    radial-gradient(at 0% 0%,   rgba(0,221,221,0.08)  0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(131,51,198,0.10) 0px, transparent 50%),
    radial-gradient(at 50% 100%,rgba(0,35,102,0.25)   0px, transparent 55%);
  position: relative;
  overflow: hidden;
}
.faq-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 40px 40px;
  opacity: 0.18;
  pointer-events: none;
}
/* Badge */
.faq-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 5px 18px;
  border-radius: 9999px;
  background: rgba(0,46,46,0.40);
  border: 1px solid rgba(0,221,221,0.28);
  box-shadow: 0 0 10px rgba(0,221,221,0.14);
  color: #00dddd;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  font-family: 'Manrope', sans-serif;
  width: fit-content;
  align-self: center;
  margin: 0 auto 20px;
}
/* Category tabs */
.faq-section .category-pill {
  padding: 7px 18px;
  border-radius: 9999px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
  border: 1px solid rgba(255,255,255,0.12);
  background: rgba(0,35,102,0.25);
  color: rgba(212,227,255,0.70);
  font-family: 'Manrope', sans-serif;
}
.faq-section .category-pill:hover {
  border-color: rgba(0,221,221,0.40);
  background: rgba(0,35,102,0.45);
  color: #fff;
  transform: translateY(-2px);
  box-shadow: 0 0 12px rgba(0,221,221,0.15);
}
.faq-section .category-pill.active {
  background: linear-gradient(135deg, #002366 0%, #8333c6 100%);
  color: #fff;
  border-color: transparent;
  box-shadow: 0 0 16px rgba(131,51,198,0.30);
}
/* FAQ accordion items */
.faq-section .faq-item {
  background: rgba(0,35,102,0.30);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 16px;
  overflow: hidden;
  transition: border-color 0.3s ease, box-shadow 0.3s ease, transform 0.3s ease;
}
.faq-section .faq-item:hover {
  border-color: rgba(0,221,221,0.22);
  transform: translateY(-1px);
}
.faq-section .faq-item.open {
  border-color: rgba(0,221,221,0.38);
  box-shadow: 0 0 20px rgba(0,221,221,0.10), 0 4px 24px rgba(0,0,0,0.25);
  background: rgba(0,46,46,0.28);
}
/* FAQ trigger button */
.faq-section .faq-trigger {
  color: rgba(255,255,255,0.90) !important;
  font-family: 'Manrope', sans-serif;
  font-size: 14px;
  font-weight: 600;
}
.faq-section .faq-trigger:hover {
  color: #00dddd !important;
}
.faq-section .faq-item.open .faq-trigger {
  color: #00dddd !important;
}
/* Accordion icon */
.faq-section .accordion-icon {
  color: rgba(0,221,221,0.60) !important;
  transition: transform 0.3s ease, color 0.3s ease;
}
.faq-section .faq-item.open .accordion-icon {
  color: #00dddd !important;
}
/* Answer text */
.faq-section .accordion-content p {
  color: rgba(212,227,255,0.72) !important;
  font-family: 'Manrope', sans-serif;
  font-size: 14px;
  line-height: 1.7;
}
/* Reveal */
.faq-reveal {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.faq-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
@media(prefers-reduced-motion:reduce){
  .faq-section *,
  .faq-section *::before,
  .faq-section *::after {
    animation: none !important;
    transition: none !important;
  }
  .faq-reveal { opacity:1; transform:none; }
}

/* ══════════════════════════════════════════
   BUILDERS / TEAM SECTION — Premium Dark
══════════════════════════════════════════ */
.builders-section {
  background-color: #020b2d;
  background-image:
    radial-gradient(at 0% 0%,   rgba(0,221,221,0.08)  0px, transparent 50%),
    radial-gradient(at 100% 100%,rgba(131,51,198,0.12) 0px, transparent 50%),
    radial-gradient(at 50% 50%, rgba(0,35,102,0.20)   0px, transparent 60%);
  position: relative;
  overflow: hidden;
}
.builders-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 40px 40px;
  opacity: 0.18;
  pointer-events: none;
}
/* Badge */
.builders-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 5px 18px;
  border-radius: 9999px;
  background: rgba(131,51,198,0.18);
  border: 1px solid rgba(131,51,198,0.35);
  box-shadow: 0 0 10px rgba(131,51,198,0.18);
  color: #dfb7ff;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  font-family: 'Manrope', sans-serif;
  width: fit-content;
  margin: 0 auto 20px;
}
/* Team card */
.builder-card {
  background: rgba(0,35,102,0.35);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 24px;
  padding: 36px 28px;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  position: relative;
  overflow: hidden;
  transition: transform 0.4s ease, border-color 0.4s ease, box-shadow 0.4s ease;
}
/* Shimmer sweep */
.builder-card::after {
  content: '';
  position: absolute;
  top: -50%; left: -60%;
  width: 40%; height: 200%;
  background: rgba(255,255,255,0.05);
  transform: skewX(-20deg);
  transition: left 0.6s ease;
  pointer-events: none;
}
.builder-card:hover::after { left: 130%; }
.builder-card:hover {
  transform: translateY(-10px) scale(1.02);
  border-color: rgba(0,221,221,0.35);
  box-shadow: 0 0 30px rgba(0,221,221,0.12), 0 20px 50px rgba(0,0,0,0.35);
}
/* Avatar wrapper */
.builder-avatar-wrap {
  position: relative;
  width: 130px; height: 130px;
  border-radius: 50%;
  margin-bottom: 20px;
  flex-shrink: 0;
}
.builder-avatar-wrap::before {
  content: '';
  position: absolute;
  inset: -4px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00dddd, #8333c6);
  opacity: 0.55;
  transition: opacity 0.4s ease;
  z-index: 0;
}
.builder-card:hover .builder-avatar-wrap::before {
  opacity: 1;
}
.builder-avatar {
  position: relative;
  z-index: 1;
  width: 100%; height: 100%;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #020b2d;
  display: block;
  transition: transform 0.4s ease;
}
.builder-card:hover .builder-avatar {
  transform: scale(1.06);
}
/* Role badge */
.builder-role-badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 14px;
  border-radius: 9999px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-family: 'Manrope', sans-serif;
  margin-bottom: 10px;
}
.builder-role-badge.leader {
  background: rgba(0,221,221,0.15);
  border: 1px solid rgba(0,221,221,0.30);
  color: #00dddd;
}
.builder-role-badge.developer {
  background: rgba(131,51,198,0.18);
  border: 1px solid rgba(131,51,198,0.35);
  color: #dfb7ff;
}
/* Name */
.builder-name {
  color: #fff;
  font-weight: 800;
  font-size: 18px;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  margin-bottom: 6px;
}
/* Role text */
.builder-role-text {
  color: rgba(212,227,255,0.65);
  font-size: 13px;
  font-family: 'Manrope', sans-serif;
  margin-bottom: 24px;
}
/* Portfolio button */
.builder-portfolio-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 10px 24px;
  border-radius: 9999px;
  background: linear-gradient(135deg, #002366 0%, #8333c6 100%);
  color: #fff;
  font-weight: 700;
  font-size: 13px;
  font-family: 'Manrope', sans-serif;
  text-decoration: none;
  border: none;
  box-shadow: 0 4px 16px rgba(131,51,198,0.28);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  margin-top: auto;
}
.builder-portfolio-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(131,51,198,0.50);
  color: #fff;
}
/* Reveal */
.builders-reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.builders-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
@media(prefers-reduced-motion:reduce){
  .builders-section *,
  .builders-section *::before,
  .builders-section *::after {
    animation: none !important;
    transition: none !important;
  }
  .builders-reveal { opacity:1; transform:none; }
}

/* ══════════════════════════════════════════
   FOOTER — Premium Dark
══════════════════════════════════════════ */
.footer-section {
  background-color: #020817;
  background-image:
    radial-gradient(at 0% 0%,   rgba(0,221,221,0.07)  0px, transparent 50%),
    radial-gradient(at 100% 100%,rgba(131,51,198,0.10) 0px, transparent 50%);
  position: relative;
  overflow: hidden;
}
.footer-section::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  opacity: 0.15;
  pointer-events: none;
}
/* Top gradient divider */
.footer-top-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, #00dddd 30%, #8333c6 70%, transparent 100%);
  opacity: 0.35;
  margin-bottom: 0;
}
/* Footer heading */
.footer-heading {
  color: #fff;
  font-weight: 700;
  font-size: 14px;
  font-family: 'Plus Jakarta Sans', 'Manrope', sans-serif;
  letter-spacing: 0.05em;
  margin-bottom: 16px;
}
/* Footer description */
.footer-description {
  color: rgba(212,227,255,0.62);
  font-size: 13px;
  line-height: 1.7;
  font-family: 'Manrope', sans-serif;
}
/* Powered text */
.footer-powered {
  font-size: 12px;
  font-weight: 700;
  color: #00dddd;
  font-family: 'Manrope', sans-serif;
}
/* Footer links */
.footer-link {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: rgba(212,227,255,0.55);
  font-size: 13px;
  font-family: 'Manrope', sans-serif;
  text-decoration: none;
  transition: color 0.25s ease, transform 0.25s ease;
}
.footer-link:hover {
  color: #00dddd;
  transform: translateX(4px);
}
/* CTA button */
.footer-cta-button {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 11px 26px;
  border-radius: 9999px;
  background: linear-gradient(135deg, #002366 0%, #8333c6 100%);
  color: #fff;
  font-weight: 700;
  font-size: 13px;
  font-family: 'Manrope', sans-serif;
  text-decoration: none;
  box-shadow: 0 4px 16px rgba(131,51,198,0.28);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.footer-cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(131,51,198,0.50);
  color: #fff;
}
/* Bottom bar */
.footer-bottom {
  border-top: 1px solid rgba(255,255,255,0.07);
  margin-top: 48px;
  padding-top: 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
  justify-content: space-between;
}
@media(min-width:768px){
  .footer-bottom { flex-direction: row; }
}
.footer-copy {
  color: rgba(212,227,255,0.40);
  font-size: 12px;
  font-family: 'Manrope', sans-serif;
}
.footer-campus {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #00dddd;
  font-size: 12px;
  font-weight: 600;
  font-family: 'Manrope', sans-serif;
}
/* Reveal */
.footer-reveal {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.55s ease, transform 0.55s ease;
}
.footer-reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
@media(prefers-reduced-motion:reduce){
  .footer-section *,
  .footer-section *::before,
  .footer-section *::after {
    animation: none !important;
    transition: none !important;
  }
  .footer-reveal { opacity:1; transform:none; }
}
</style>
</head>
<body>

<!--  PREMIUM NAVBAR  -->
<nav class="fixed top-0 w-full z-50 premium-navbar" id="navbar">
  <div class="flex items-center justify-between px-6 md:px-10 py-3 max-w-7xl mx-auto">
    <!-- Logo -->
    <a href="#home" class="flex items-center gap-2 no-underline">
      <div class="cuichat-logo-wrap">
        <img src="{{ asset('asset/cuichat-logo.png') }}?v=20260514-logo2" alt="CUI_CHAT Logo" class="cuichat-logo-img">
      </div>
      <span class="text-xl font-black text-white tracking-tight">CUI_CHAT</span>
    </a>
    <!-- Desktop Nav Links -->
    <div class="hidden lg:flex items-center gap-1">
      <a href="#home" class="pnav-link active-link">Home</a>
      <!-- Why CUICHAT Dropdown -->
      <div class="relative nav-item">
        <button class="pnav-link flex items-center gap-1 bg-transparent border-0 cursor-pointer" id="whyBtn" style="font-family:inherit;">
          Why CUI_CHAT <span class="material-symbols-outlined" style="font-size:18px;line-height:1;">expand_more</span>
        </button>
        <div class="nav-dropdown rounded-2xl shadow-2xl p-2">
          <a href="#why-cuichat" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-colors no-underline group">
            <span class="material-symbols-outlined text-xl" style="color:#b3c5ff;">compare_arrows</span>
            <div>
              <div class="text-sm font-semibold" style="color:#b3c5ff;">What's Different</div>
              <div class="text-xs" style="color:rgba(255,255,255,0.45);">vs WhatsApp groups</div>
            </div>
          </a>
          <a href="#premium-features" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-colors no-underline group">
            <span class="material-symbols-outlined text-xl" style="color:#dfb7ff;">auto_awesome</span>
            <div>
              <div class="text-sm font-semibold" style="color:#dfb7ff;">Premium Features</div>
              <div class="text-xs" style="color:rgba(255,255,255,0.45);">Roadmap capabilities</div>
            </div>
          </a>
        </div>
      </div>
      <a href="#features"  class="pnav-link">Features</a>
      <a href="#campuses"  class="pnav-link">Campuses</a>
      <a href="#team"      class="pnav-link">Team</a>
      <a href="#faqs"      class="pnav-link">FAQ's</a>
      <a href="#about"     class="pnav-link">About</a>
    </div>
    <!-- Right side -->
    <div class="flex items-center gap-3">
      <a href="#features" class="hidden md:inline-flex pnav-explore">Explore CUI_CHAT</a>
      <button class="lg:hidden p-2 rounded-xl transition-colors bg-transparent border-0 cursor-pointer" id="menuToggle" style="color:#fff;">
        <span class="material-symbols-outlined">menu</span>
      </button>
    </div>
  </div>
  <!-- Mobile Menu -->
  <div class="mobile-menu px-6 pb-4" id="mobileMenu">
    <a href="#home" class="py-3 font-bold border-b block no-underline">Home</a>
    <!-- Mobile Why CUICHAT -->
    <div class="border-b" style="border-color:rgba(255,255,255,0.08);">
      <button class="py-3 font-semibold w-full text-left flex items-center justify-between bg-transparent border-0 cursor-pointer" id="mobileWhyBtn" style="color:rgba(255,255,255,0.82);font-family:inherit;">
        Why CUI_CHAT <span class="material-symbols-outlined text-sm accordion-icon" id="mobileWhyIcon">expand_more</span>
      </button>
      <div class="accordion-content pl-4 space-y-1" id="mobileWhyMenu">
        <a href="#why-cuichat" class="py-2 text-sm flex items-center gap-2 no-underline" style="color:rgba(255,255,255,0.65);"><span class="material-symbols-outlined text-sm" style="color:#b3c5ff;">compare_arrows</span>What's Different</a>
        <a href="#premium-features" class="py-2 text-sm flex items-center gap-2 no-underline" style="color:rgba(255,255,255,0.65);"><span class="material-symbols-outlined text-sm" style="color:#dfb7ff;">auto_awesome</span>Premium Features</a>
      </div>
    </div>
    <a href="#features"  class="py-3 font-medium border-b block no-underline" style="border-color:rgba(255,255,255,0.08);">Features</a>
    <a href="#campuses"  class="py-3 font-medium border-b block no-underline" style="border-color:rgba(255,255,255,0.08);">Campuses</a>
    <a href="#team"      class="py-3 font-medium border-b block no-underline" style="border-color:rgba(255,255,255,0.08);">Team</a>
    <a href="#faqs"      class="py-3 font-medium border-b block no-underline" style="border-color:rgba(255,255,255,0.08);">FAQ's</a>
    <a href="#about"     class="py-3 font-medium block no-underline">About</a>
  </div>
</nav>


<!--  PREMIUM HERO SECTION  -->
<main>
<section class="premium-hero relative min-h-screen flex items-center pt-20 pb-24 px-6 md:px-10" id="hero-section">
  <!-- Ambient glow blobs -->
  <div class="ph-blob-purple"></div>
  <div class="ph-blob-cyan"></div>

  <div class="max-w-7xl mx-auto w-full grid grid-cols-1 lg:grid-cols-12 gap-12 items-center relative z-10">

    <!-- ── Left Column: Content ── -->
    <div class="lg:col-span-6 flex flex-col items-start gap-6">

      <!-- Badge -->
      <div class="inline-flex items-center gap-2 px-4 py-2 hero-glow-pill rounded-full">
        <span class="material-symbols-outlined text-[18px]" style="font-variation-settings:'FILL' 1;color:#00fbfb;">verified</span>
        <span class="text-xs font-bold tracking-widest uppercase" style="color:#00fbfb;">Official COMSATS Social Network</span>
      </div>

      <!-- Heading -->
      <h1 class="text-4xl md:text-5xl lg:text-6xl font-black text-white leading-tight tracking-tight" style="font-family:'Manrope',sans-serif;">
        CUI_CHAT<br>
        <span class="hero-gradient-text">Connect COMSATS<br>Campuses</span>
      </h1>

      <!-- Paragraph -->
      <p class="text-lg leading-relaxed max-w-xl" style="color:rgba(255,255,255,0.70);">
        A verified digital ecosystem exclusively for COMSATS University Islamabad. Foster collaboration, spark discussions, and build meaningful networks across all seven campuses.
      </p>

      <!-- CTA Buttons -->
      <div class="flex flex-wrap gap-4 pt-2 w-full">
        <a href="javascript:void(0)" class="hero-btn-primary px-8 py-4 rounded-2xl font-bold text-base shadow-xl" title="Download CUI_CHAT App">
          <span class="material-symbols-outlined text-sm">download</span> Download App
        </a>
        <a href="#why-cuichat" class="hero-btn-secondary px-8 py-4 rounded-2xl font-bold text-base">
          <span class="material-symbols-outlined text-sm">compare_arrows</span> Why CUI_CHAT?
        </a>
      </div>

      <!-- Trust Chips -->
      <div class="flex flex-wrap gap-3 mt-2">
        <div class="hero-chip flex items-center gap-2 px-4 py-2 rounded-xl">
          <span class="material-symbols-outlined text-[22px]" style="color:#00fbfb;">verified_user</span>
          <span class="text-sm font-semibold">Verified Access</span>
        </div>
        <div class="hero-chip flex items-center gap-2 px-4 py-2 rounded-xl">
          <span class="material-symbols-outlined text-[22px]" style="color:#00fbfb;">security</span>
          <span class="text-sm font-semibold">Admin Approved</span>
        </div>
        <div class="hero-chip flex items-center gap-2 px-4 py-2 rounded-xl">
          <span class="material-symbols-outlined text-[22px]" style="color:#00fbfb;">corporate_fare</span>
          <span class="text-sm font-semibold">7 Campuses</span>
        </div>
      </div>
    </div>

    <!-- ── Right Column: Mockup + Floating Badges ── -->
    <div class="lg:col-span-6 relative flex justify-center lg:justify-center" style="padding-right:0;">
      <!-- Glow behind mockup -->
      <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
        <div style="width:420px;height:420px;background:radial-gradient(circle,rgba(131,51,198,0.30) 0%,transparent 70%);border-radius:50%;filter:blur(40px);"></div>
      </div>

      <!-- Mockup image — wider + shifted left via margin -->
      <div class="relative z-10 ph-mockup-float" style="max-width:400px;width:100%;margin-right:40px;">
        <img
          src="{{ asset('asset/Mockup.png') }}"
          alt="CUI_CHAT App Mockup"
          class="w-full h-auto object-contain"
          style="filter:drop-shadow(0 40px 80px rgba(0,0,0,0.55)) drop-shadow(0 0 40px rgba(131,51,198,0.35));"
          loading="eager"
        >

        <!-- Badge 1: Verified Student — top-left, expands right -->
        <div class="hfb-badge ph-float"
             role="img"
             aria-label="Verified Student"
             title="Verified Student"
             tabindex="0"
             style="top:10%;left:-22%;animation-delay:0s;z-index:22;">
          <div class="hfb-icon"
               style="background:rgba(0,251,251,0.18);border:1px solid rgba(0,251,251,0.30);">
            <span class="material-symbols-outlined"
                  style="color:#00fbfb;font-variation-settings:'FILL' 1;">verified</span>
          </div>
          <span class="hfb-label">Verified Student</span>
        </div>

        <!-- Badge 2: 12 new messages — upper-right, expands left -->
        <div class="hfb-badge ph-float-2"
             role="img"
             aria-label="12 new messages"
             title="12 new messages"
             tabindex="0"
             style="top:26%;right:-24%;animation-delay:1.5s;z-index:22;flex-direction:row-reverse;">
          <div class="hfb-icon"
               style="background:rgba(131,51,198,0.28);border:1px solid rgba(131,51,198,0.40);">
            <span class="material-symbols-outlined"
                  style="color:#dfb7ff;">mark_chat_unread</span>
          </div>
          <span class="hfb-label" style="transform:translateX(8px);">12 new messages</span>
        </div>

        <!-- Badge 3: 3 Notifications — mid-left, well above Islamabad Campus -->
        <div class="hfb-badge ph-float-3"
             role="img"
             aria-label="3 Notifications"
             title="3 Notifications"
             tabindex="0"
             style="bottom:44%;left:-24%;animation-delay:0.8s;z-index:22;">
          <div class="hfb-icon"
               style="background:rgba(186,26,26,0.28);border:1px solid rgba(186,26,26,0.40);">
            <span class="material-symbols-outlined"
                  style="color:#ff6b6b;font-variation-settings:'FILL' 1;">notifications_active</span>
          </div>
          <span class="hfb-label">3 Notifications</span>
        </div>

        <!-- Badge 4: CS Study Room — lower-right, expands left -->
        <div class="hfb-badge ph-float-4"
             role="img"
             aria-label="CS Study Room"
             title="CS Study Room"
             tabindex="0"
             style="bottom:18%;right:-24%;animation-delay:2.2s;z-index:22;flex-direction:row-reverse;">
          <div class="hfb-icon"
               style="background:rgba(0,251,251,0.22);border:1px solid rgba(0,251,251,0.30);">
            <span class="material-symbols-outlined"
                  style="color:#00fbfb;">menu_book</span>
          </div>
          <span class="hfb-label" style="transform:translateX(8px);">CS Study Room</span>
        </div>

        <!-- Badge 5: Islamabad Campus — lower-left, clear gap below Badge 3 -->
        <div class="hfb-badge ph-float"
             role="img"
             aria-label="Islamabad Campus"
             title="Islamabad Campus"
             tabindex="0"
             style="bottom:26%;left:-24%;animation-delay:3s;z-index:22;">
          <div class="hfb-icon"
               style="background:rgba(67,91,159,0.30);border:1px solid rgba(67,91,159,0.45);">
            <span class="material-symbols-outlined"
                  style="color:#b3c5ff;font-variation-settings:'FILL' 1;">location_on</span>
          </div>
          <span class="hfb-label">Islamabad Campus</span>
        </div>
      </div>
    </div>

  </div>
</section>


<!--  PARTICLES TRANSITION  -->
<div class="relative py-12 md:py-16 overflow-hidden -mt-1" style="background:linear-gradient(180deg,#0f1a3f 0%,#001428 100%);">
  <canvas id="particles-canvas"></canvas>
  <div class="relative z-10 text-center px-6">
    <span class="inline-block text-xs font-bold tracking-widest uppercase text-cyan-400 mb-3">Discover the Platform</span>
    <h2 class="text-3xl md:text-4xl font-black text-white mb-3">Built for COMSATS. Built for You.</h2>
    <p class="text-blue-200 max-w-xl mx-auto">A dedicated academic social network that understands your campus, your department, and your goals.</p>
  </div>
</div>

<!--  WHAT IS CUICHAT — Premium Dark Section  -->
<section class="cuichat-about-section py-24 px-6 md:px-12" id="about">

  <!-- Background orbs -->
  <div class="cuichat-about-orb" style="width:500px;height:500px;background:rgba(131,51,198,0.20);top:-80px;left:-80px;"></div>
  <div class="cuichat-about-orb" style="width:400px;height:400px;background:rgba(0,221,221,0.08);bottom:60px;right:-80px;"></div>

  <!-- Star particles -->
  <div class="cuichat-about-star" style="top:22%;left:30%;"></div>
  <div class="cuichat-about-star" style="top:48%;left:18%;"></div>
  <div class="cuichat-about-star" style="top:65%;left:55%;"></div>
  <div class="cuichat-about-star" style="top:20%;right:22%;"></div>
  <div class="cuichat-about-star" style="bottom:28%;right:35%;"></div>
  <div class="cuichat-about-star" style="top:38%;right:10%;"></div>

  <div class="max-w-7xl mx-auto relative z-10">

    <!-- Section header -->
    <div class="text-center mb-16 cuichat-about-reveal">
      <div class="cuichat-about-badge mb-5">About the Platform</div>
      <h2 class="text-4xl md:text-5xl font-black text-white mb-5 leading-tight" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        What is <span class="cuichat-about-gradient-text">CUI_CHAT?</span>
      </h2>
      <p class="text-lg max-w-2xl mx-auto leading-relaxed" style="color:rgba(212,227,255,0.80);font-family:'Manrope',sans-serif;">
        A dedicated digital ecosystem designed exclusively for the COMSATS community to collaborate, connect, and excel together.
      </p>
    </div>

    <!-- Four feature cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">

      <!-- Card 1: Social Networking -->
      <div class="cuichat-about-card p-10 flex flex-col cuichat-about-reveal" style="transition-delay:0.05s;">
        <div class="cuichat-about-icon-wrap mb-6" style="background:rgba(131,51,198,0.20);border:1px solid rgba(131,51,198,0.30);">
          <span class="material-symbols-outlined" style="font-size:28px;color:#dfb7ff;font-variation-settings:'FILL' 0,'wght' 300;">hub</span>
        </div>
        <h3 class="text-white font-bold text-lg mb-3" style="font-family:'Plus Jakarta Sans',sans-serif;">Social Networking</h3>
        <p class="leading-relaxed text-sm" style="color:rgba(212,227,255,0.70);font-family:'Manrope',sans-serif;">
          Build professional and social connections within your department or across campuses.
        </p>
      </div>

      <!-- Card 2: Verified Access -->
      <div class="cuichat-about-card p-10 flex flex-col cuichat-about-reveal" style="transition-delay:0.12s;">
        <div class="cuichat-about-icon-wrap mb-6" style="background:rgba(0,46,46,0.50);border:1px solid rgba(0,221,221,0.30);">
          <span class="material-symbols-outlined" style="font-size:28px;color:#00dddd;font-variation-settings:'FILL' 0,'wght' 300;">verified_user</span>
        </div>
        <h3 class="text-white font-bold text-lg mb-3" style="font-family:'Plus Jakarta Sans',sans-serif;">Verified Access</h3>
        <p class="leading-relaxed text-sm" style="color:rgba(212,227,255,0.70);font-family:'Manrope',sans-serif;">
          Secure registration using official university credentials for a safe, closed community.
        </p>
      </div>

      <!-- Card 3: Admin Approval -->
      <div class="cuichat-about-card p-10 flex flex-col cuichat-about-reveal" style="transition-delay:0.19s;">
        <div class="cuichat-about-icon-wrap mb-6" style="background:rgba(131,51,198,0.20);border:1px solid rgba(131,51,198,0.30);">
          <span class="material-symbols-outlined" style="font-size:28px;color:#dfb7ff;font-variation-settings:'FILL' 0,'wght' 300;">admin_panel_settings</span>
        </div>
        <h3 class="text-white font-bold text-lg mb-3" style="font-family:'Plus Jakarta Sans',sans-serif;">Admin Approval</h3>
        <p class="leading-relaxed text-sm" style="color:rgba(212,227,255,0.70);font-family:'Manrope',sans-serif;">
          Every account is vetted by campus administrators to maintain professional standards.
        </p>
      </div>

      <!-- Card 4: Campus Community -->
      <div class="cuichat-about-card p-10 flex flex-col cuichat-about-reveal" style="transition-delay:0.26s;">
        <div class="cuichat-about-icon-wrap mb-6" style="background:rgba(0,46,46,0.50);border:1px solid rgba(0,221,221,0.30);">
          <span class="material-symbols-outlined" style="font-size:28px;color:#00dddd;font-variation-settings:'FILL' 0,'wght' 300;">groups_2</span>
        </div>
        <h3 class="text-white font-bold text-lg mb-3" style="font-family:'Plus Jakarta Sans',sans-serif;">Campus Community</h3>
        <p class="leading-relaxed text-sm" style="color:rgba(212,227,255,0.70);font-family:'Manrope',sans-serif;">
          Stay updated with campus-specific news, events, and societies tailored to your location.
        </p>
      </div>

    </div>

    <!-- "The Future of Campus Life" image card -->
    <div class="mt-16 pt-16 cuichat-about-reveal" style="border-top:1px solid rgba(255,255,255,0.06);transition-delay:0.35s;">
      <div class="cuichat-about-img-card p-2">
        <div style="width:100%;height:420px;border-radius:12px;position:relative;overflow:hidden;display:flex;align-items:flex-end;">
          <!-- Actual image -->
          <img
            src="{{ asset('asset/future-campus-life.png') }}"
            alt="The Future of Campus Life"
            style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:center;border-radius:12px;opacity:0.82;"
          >
          <!-- Dark gradient overlay for text readability -->
          <div style="position:absolute;inset:0;background:linear-gradient(to top,rgba(0,17,58,0.88) 0%,rgba(0,17,58,0.30) 50%,transparent 100%);border-radius:12px;pointer-events:none;"></div>
          <!-- Text overlay -->
          <div style="position:relative;z-index:2;padding:32px;max-width:560px;">
            <h4 class="text-white font-bold text-2xl mb-3" style="font-family:'Plus Jakarta Sans',sans-serif;">The Future of Campus Life</h4>
            <p style="color:rgba(212,227,255,0.85);font-family:'Manrope',sans-serif;font-size:15px;line-height:1.6;">
              Empowering over 30,000 students across 7 campuses to innovate and share knowledge in a secure, academic-first environment.
            </p>
          </div>
        </div>
      </div>
    </div>

  </div>
</section>


<!--  WHY CUICHAT / DIFFERENCES — Premium Dark  -->
<section class="cuichat-comparison-section py-24 px-6 md:px-12" id="why-cuichat">
  <div class="max-w-7xl mx-auto relative z-10">

    <!-- Section header -->
    <div class="text-center mb-16 cuichat-comparison-reveal">
      <div class="cuichat-comparison-badge mb-5">Comparison</div>
      <h2 class="text-4xl md:text-5xl font-black text-white mb-5 leading-tight" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        Why <span style="background:linear-gradient(90deg,#00dddd 0%,#dfb7ff 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">CUI_CHAT?</span>
      </h2>
      <p class="text-lg max-w-2xl mx-auto leading-relaxed" style="color:rgba(212,227,255,0.75);font-family:'Manrope',sans-serif;">
        Why a dedicated COMSATS platform is better than scattered WhatsApp groups.
      </p>

      <!-- WhatsApp VS CUICHAT icon row -->
      <div class="cuichat-vs-row cuichat-comparison-reveal" style="transition-delay:0.15s;">

        <!-- WhatsApp -->
        <div class="cuichat-vs-brand whatsapp">
          <div class="cuichat-vs-icon">
            <!-- WhatsApp SVG icon -->
            <svg width="38" height="38" viewBox="0 0 38 38" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="19" cy="19" r="19" fill="rgba(37,211,102,0.15)"/>
              <path d="M19 7C12.373 7 7 12.373 7 19c0 2.136.558 4.14 1.532 5.876L7 31l5.29-1.508A11.94 11.94 0 0019 31c6.627 0 12-5.373 12-12S25.627 7 19 7zm0 21.818a9.8 9.8 0 01-5.01-1.374l-.358-.213-3.14.895.91-3.06-.234-.374A9.818 9.818 0 1119 28.818zm5.39-7.348c-.295-.148-1.748-.862-2.019-.96-.27-.099-.467-.148-.663.148-.197.295-.762.96-.934 1.157-.172.197-.344.222-.639.074-.295-.148-1.245-.459-2.372-1.463-.877-.782-1.469-1.748-1.641-2.043-.172-.295-.018-.454.129-.601.132-.132.295-.344.443-.516.148-.172.197-.295.295-.492.099-.197.05-.37-.025-.517-.074-.148-.663-1.6-.908-2.19-.24-.574-.483-.496-.663-.505l-.566-.01c-.197 0-.517.074-.787.37-.27.295-1.033 1.01-1.033 2.462s1.058 2.855 1.206 3.052c.148.197 2.082 3.178 5.044 4.458.705.304 1.255.486 1.684.622.708.225 1.352.193 1.861.117.568-.085 1.748-.714 1.995-1.404.246-.69.246-1.28.172-1.404-.074-.123-.27-.197-.566-.344z" fill="#25D366"/>
            </svg>
          </div>
          <span class="cuichat-vs-label">WhatsApp</span>
        </div>

        <!-- VS pill -->
        <div class="cuichat-vs-pill">VS</div>

        <!-- CUICHAT -->
        <div class="cuichat-vs-brand cuichat">
          <div class="cuichat-vs-icon">
            <img src="{{ asset('asset/cuichat-logo.png') }}?v=20260514-logo2" alt="CUI_CHAT" style="width:44px;height:44px;object-fit:cover;border-radius:14px;transform:scale(1.15);filter:brightness(1.15) contrast(1.10);">
          </div>
          <span class="cuichat-vs-label">CUI_CHAT</span>
        </div>

      </div>
    </div>

    <!-- Comparison cards grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      @php
      $comparisons = [
        ["icon"=>"flag","title"=>"Purpose","wa"=>["General personal messaging"],"cui"=>["COMSATS-specific academic + social platform"]],
        ["icon"=>"person_add","title"=>"User Access","wa"=>["Phone number based","Anyone can join groups"],"cui"=>["Verified COMSATS student/faculty only"]],
        ["icon"=>"verified","title"=>"Verification","wa"=>["No university verification"],"cui"=>["OTP verification","Admin approval","Registration details review"]],
        ["icon"=>"school","title"=>"Academic Context","wa"=>["No department, batch, or campus identity"],"cui"=>["Department-based identity","Batch-based identity","Campus-based identity","Student/faculty role identity"]],
        ["icon"=>"gavel","title"=>"Moderation","wa"=>["Group admins only","Limited control"],"cui"=>["Central admin panel","Moderators","Reports","Restricted content control"]],
        ["icon"=>"campaign","title"=>"Announcements","wa"=>["Messages get lost in chat"],"cui"=>["Official announcements","Pinned updates","Campus/department announcements"]],
        ["icon"=>"folder_shared","title"=>"Resource Sharing","wa"=>["Files scattered in chats"],"cui"=>["Dedicated notes, papers, and resource library roadmap"]],
        ["icon"=>"travel_explore","title"=>"Discovery","wa"=>["No structured discovery"],"cui"=>["Interest discovery","Department discovery","Campus discovery","Batch discovery"]],
        ["icon"=>"location_city","title"=>"Campus Coverage","wa"=>["Separate random groups"],"cui"=>["One platform for all 7 COMSATS campuses"]],
        ["icon"=>"badge","title"=>"Faculty Role","wa"=>["Same as normal user"],"cui"=>["Verified faculty profiles","Announcements","Office hours roadmap"]],
        ["icon"=>"event","title"=>"Events","wa"=>["No proper RSVP/reminder system"],"cui"=>["Campus events","RSVP","Reminders roadmap"]],
        ["icon"=>"analytics","title"=>"Analytics","wa"=>["No university analytics"],"cui"=>["Admin dashboard for growth, reports, and usage"]],
        ["icon"=>"mic","title"=>"Live Collaboration","wa"=>["Voice/video calls only"],"cui"=>["Live audio rooms for study, FYP, and societies"]],
        ["icon"=>"security","title"=>"Safety","wa"=>["Outsiders/fake numbers possible"],"cui"=>["Verified access","Block/report system","Admin approval"]],
        ["icon"=>"layers","title"=>"Scalability","wa"=>["Group-based chaos"],"cui"=>["Structured modules: feed, rooms, chat, resources, events"]],
      ];
      @endphp

      @foreach($comparisons as $i => $c)
      <div class="cuichat-comparison-card p-6 cuichat-comparison-reveal" style="transition-delay:{{ ($i % 6) * 0.07 }}s;">

        <!-- Card header: icon + title -->
        <div class="flex items-center gap-3 mb-5">
          <div class="cuichat-compare-icon">
            <span class="material-symbols-outlined text-white" style="font-size:22px;font-variation-settings:'FILL' 1;">{{ $c['icon'] }}</span>
          </div>
          <h3 class="font-bold text-white text-base" style="font-family:'Plus Jakarta Sans',sans-serif;">{{ $c['title'] }}</h3>
        </div>

        <!-- Two-panel comparison -->
        <div class="flex flex-col gap-3">

          <!-- WhatsApp panel -->
          <div class="cuichat-compare-whatsapp">
            <div class="flex items-center gap-1.5 mb-2">
              <span class="material-symbols-outlined text-red-400" style="font-size:14px;">close</span>
              <span class="text-xs font-bold text-red-400 tracking-wide uppercase">WhatsApp</span>
            </div>
            @foreach($c['wa'] as $item)
            <div class="cuichat-compare-point">
              <span class="material-symbols-outlined text-red-400 flex-shrink-0" style="font-size:13px;margin-top:1px;">remove</span>
              <span style="color:rgba(212,227,255,0.65);">{{ $item }}</span>
            </div>
            @endforeach
          </div>

          <!-- CUICHAT panel -->
          <div class="cuichat-compare-cuichat">
            <div class="flex items-center gap-1.5 mb-2">
              <span class="material-symbols-outlined text-[#00dddd]" style="font-size:14px;font-variation-settings:'FILL' 1;">check_circle</span>
              <span class="text-xs font-bold text-[#00dddd] tracking-wide uppercase">CUI_CHAT</span>
            </div>
            @foreach($c['cui'] as $item)
            <div class="cuichat-compare-point">
              <span class="material-symbols-outlined text-[#00dddd] flex-shrink-0" style="font-size:13px;margin-top:1px;font-variation-settings:'FILL' 1;">check</span>
              <span class="font-medium" style="color:rgba(255,255,255,0.90);">{{ $item }}</span>
            </div>
            @endforeach
          </div>

        </div>
      </div>
      @endforeach
    </div>

  </div>
</section>



<!--  CORE FEATURES — Premium Dark  -->
<section class="cuichat-features-section py-24 px-6 md:px-12" id="features">

  <!-- Glow blobs -->
  <div class="cuichat-features-glow-blob" style="top:-100px;left:-100px;background:rgba(0,251,251,0.08);"></div>
  <div class="cuichat-features-glow-blob" style="bottom:-100px;right:-100px;background:rgba(131,51,198,0.10);"></div>

  <div class="max-w-7xl mx-auto relative z-10">

    <!-- Section header -->
    <div class="flex flex-col items-center text-center mb-16 cuichat-features-reveal">
      <div class="cuichat-features-badge mb-5">Platform Features</div>
      <div>
        <h2 class="text-4xl md:text-5xl font-black text-white leading-tight" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
          Core Platform Features
        </h2>
        <div class="cuichat-features-underline"></div>
      </div>
    </div>

    <!-- Features grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      @php
      $features = [
        ["icon"=>"account_circle","title"=>"Profiles","desc"=>"Comprehensive student and faculty profiles highlighting skills, research, and campus status."],
        ["icon"=>"hub","title"=>"Connectivity","desc"=>"Seamless real-time messaging and collaborative groups across all COMSATS locations."],
        ["icon"=>"verified_user","title"=>"Registration Approval","desc"=>"Automated vetting combined with manual admin oversight for ironclad platform security."],
        ["icon"=>"psychology","title"=>"Interests","desc"=>"Algorithm-based suggestions to connect you with peers who share your academic passions."],
        ["icon"=>"auto_awesome_motion","title"=>"Posts & Reels","desc"=>"Share campus life moments and academic breakthroughs through rich media feeds and short clips."],
        ["icon"=>"mic_external_on","title"=>"Live Audio Rooms","desc"=>"Join real-time study sessions, FYP discussions, and faculty-led Q&A sessions."],
        ["icon"=>"gavel","title"=>"Moderation","desc"=>"Advanced moderation tools ensure the platform remains a safe space for professional growth."],
        ["icon"=>"notifications_active","title"=>"Push Notifications","desc"=>"Stay updated with campus announcements, messages, and activity alerts in real time."],
        ["icon"=>"history_toggle_off","title"=>"Stories","desc"=>"Share 24-hour campus moments and updates with your university network."],
      ];
      @endphp

      @foreach($features as $i => $f)
      <div class="cuichat-feature-card p-10 flex flex-col cuichat-features-reveal" style="transition-delay:{{ ($i % 6) * 0.08 }}s;">

        <!-- Watermark icon -->
        <span class="material-symbols-outlined cuichat-feature-watermark">{{ $f['icon'] }}</span>

        <!-- Icon circle -->
        <div class="cuichat-feature-icon">
          <span class="material-symbols-outlined text-[#00fbfb]" style="font-size:28px;">{{ $f['icon'] }}</span>
        </div>

        <!-- Title -->
        <h3 class="text-white font-bold text-lg mb-3" style="font-family:'Plus Jakarta Sans',sans-serif;">{{ $f['title'] }}</h3>

        <!-- Description -->
        <p class="leading-relaxed text-sm" style="color:rgba(212,227,255,0.75);font-family:'Manrope',sans-serif;">
          {{ $f['desc'] }}
        </p>

      </div>
      @endforeach
    </div>

  </div>
</section>


<!--  CAMPUSES — Premium Network Map v2  -->
<section class="cuichat-network-section py-24 px-6 md:px-12" id="campuses">

  <!-- Background grid -->
  <div class="cuichat-network-grid"></div>

  <!-- Ambient glow blobs -->
  <div style="position:absolute;top:20%;left:-80px;width:500px;height:500px;background:rgba(131,51,198,0.10);filter:blur(120px);border-radius:50%;pointer-events:none;z-index:0;"></div>
  <div style="position:absolute;bottom:20%;right:-80px;width:600px;height:600px;background:rgba(0,221,221,0.05);filter:blur(150px);border-radius:50%;pointer-events:none;z-index:0;"></div>

  <!-- Particle dots -->
  <div style="position:absolute;top:10%;right:20%;width:4px;height:4px;background:#fff;border-radius:50%;opacity:0.40;box-shadow:0 0 10px #fff;pointer-events:none;"></div>
  <div style="position:absolute;bottom:20%;left:10%;width:6px;height:6px;background:#00dddd;border-radius:50%;opacity:0.60;box-shadow:0 0 15px #00dddd;pointer-events:none;"></div>
  <div style="position:absolute;top:40%;left:5%;width:4px;height:4px;background:#b96cfd;border-radius:50%;opacity:0.50;box-shadow:0 0 12px #b96cfd;pointer-events:none;"></div>

  <div class="max-w-7xl mx-auto relative z-10">

    <!-- Section header -->
    <div class="text-center mb-16 cuichat-network-reveal">
      <div class="cuichat-network-badge mb-5">
        Network Coverage
        <div class="cuichat-network-badge-dot"></div>
      </div>
      <h2 class="text-4xl md:text-5xl font-black text-white mb-4 leading-tight" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        Unified <span style="background:linear-gradient(90deg,#00dddd 0%,#b96cfd 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">COMSATS Network</span>
      </h2>
      <p class="text-lg max-w-xl mx-auto" style="color:rgba(212,227,255,0.80);font-family:'Manrope',sans-serif;">
        Connecting seven vibrant campuses into one digital family.
      </p>
    </div>

    <!-- ── DESKTOP: Radial network map ── -->
    <div class="hidden md:flex cuichat-network-map items-center justify-center">

      <!-- SVG connector lines — viewBox coords, path elements for reliable dash animation -->
      <svg class="cuichat-network-svg" viewBox="0 0 1000 600" preserveAspectRatio="none" style="position:absolute;inset:0;width:100%;height:100%;pointer-events:none;overflow:visible;">
        <defs>
          <linearGradient id="cn-grad-v2" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="1000" y2="600">
            <stop offset="0%"   stop-color="#00dddd"/>
            <stop offset="100%" stop-color="#8333c6"/>
          </linearGradient>
          <filter id="cn-glow" x="-50%" y="-50%" width="200%" height="200%">
            <feGaussianBlur stdDeviation="3" result="blur"/>
            <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
          </filter>
        </defs>
        <!--
          viewBox 1000x600. Hub visual center: 500,282 (50% x, 47% y).
          Node pill centers:
            Islamabad:  10%,10%  → 100, 60
            Lahore:     90%,10%  → 900, 60
            Abbottabad: 10%,50%  → 100,300
            Wah:        90%,50%  → 900,300
            Attock:     12%,88%  → 120,528
            Vehari:     50%,94%  → 500,564
            Sahiwal:    88%,88%  → 880,528
          Slight Q curve offset ensures non-zero bounding box on near-horizontal/vertical
          paths so stroke-dashoffset animation works in all browsers.
        -->
        <path class="cuichat-network-line" data-line="islamabad"  d="M500,282 Q300,171 100,60"/>
        <path class="cuichat-network-line" data-line="lahore"     d="M500,282 Q700,171 900,60"/>
        <path class="cuichat-network-line" data-line="abbottabad" d="M500,282 Q300,291 100,300"/>
        <path class="cuichat-network-line" data-line="wah"        d="M500,282 Q700,291 900,300"/>
        <path class="cuichat-network-line" data-line="attock"     d="M500,282 Q310,405 120,528"/>
        <path class="cuichat-network-line" data-line="vehari"     d="M500,282 Q508,423 500,564"/>
        <path class="cuichat-network-line" data-line="sahiwal"    d="M500,282 Q690,405 880,528"/>
      </svg>

      <!-- Central hub — perfectly centered via flex -->
      <div class="cuichat-network-hub px-10 py-8 flex flex-col items-center text-center cuichat-network-reveal" id="cn-hub" style="min-width:220px;transition-delay:0.1s;z-index:30;">
        <div class="cuichat-network-hub-icon">
          <span class="material-symbols-outlined text-[#00dddd]" style="font-size:48px;font-variation-settings:'FILL' 0,'wght' 300;">hub</span>
        </div>
        <h3 class="text-white font-bold text-xl" style="font-family:'Plus Jakarta Sans',sans-serif;">CUI_CHAT Network</h3>
      </div>

      <!-- Campus nodes — absolute positioned around the centered hub -->
      <!-- Top-left: Islamabad -->
      <div class="absolute cuichat-network-reveal cn-float-1" data-campus="islamabad" style="top:8%;left:6%;transition-delay:0.15s;">
        <div class="cuichat-campus-node"><div class="cuichat-campus-dot-cyan"></div>Islamabad</div>
      </div>
      <!-- Top-right: Lahore -->
      <div class="absolute cuichat-network-reveal cn-float-2" data-campus="lahore" style="top:8%;right:6%;transition-delay:0.20s;">
        <div class="cuichat-campus-node"><div class="cuichat-campus-dot-purple"></div>Lahore</div>
      </div>
      <!-- Left-center: Abbottabad -->
      <div class="absolute cuichat-network-reveal cn-float-3" data-campus="abbottabad" style="top:50%;left:0%;transform:translateY(-50%);transition-delay:0.25s;">
        <div class="cuichat-campus-node"><div class="cuichat-campus-dot-cyan"></div>Abbottabad</div>
      </div>
      <!-- Right-center: Wah -->
      <div class="absolute cuichat-network-reveal cn-float-4" data-campus="wah" style="top:50%;right:0%;transform:translateY(-50%);transition-delay:0.30s;">
        <div class="cuichat-campus-node"><div class="cuichat-campus-dot-purple"></div>Wah</div>
      </div>
      <!-- Bottom-left: Attock -->
      <div class="absolute cuichat-network-reveal cn-float-5" data-campus="attock" style="bottom:8%;left:8%;transition-delay:0.35s;">
        <div class="cuichat-campus-node"><div class="cuichat-campus-dot-cyan"></div>Attock</div>
      </div>
      <!-- Bottom-center: Vehari — wrapper uses translate for centering, float anim on inner element to avoid transform conflict -->
      <div class="absolute cuichat-network-reveal" data-campus="vehari" style="bottom:2%;left:50%;transform:translateX(-50%);transition-delay:0.40s;">
        <div class="cuichat-campus-node cn-float-6"><div class="cuichat-campus-dot-purple"></div>Vehari</div>
      </div>
      <!-- Bottom-right: Sahiwal -->
      <div class="absolute cuichat-network-reveal cn-float-7" data-campus="sahiwal" style="bottom:8%;right:8%;transition-delay:0.45s;">
        <div class="cuichat-campus-node"><div class="cuichat-campus-dot-cyan"></div>Sahiwal</div>
      </div>

    </div>

    <!-- ── MOBILE: Stacked layout ── -->
    <div class="md:hidden flex flex-col items-center gap-6">

      <!-- Central hub mobile -->
      <div class="cuichat-network-hub px-8 py-6 flex flex-col items-center text-center w-full max-w-xs cuichat-network-reveal">
        <div style="width:72px;height:72px;border-radius:50%;background:rgba(0,35,102,0.50);border:2px solid rgba(0,221,221,0.30);display:flex;align-items:center;justify-content:center;margin:0 auto 12px;">
          <span class="material-symbols-outlined text-[#00dddd]" style="font-size:36px;font-variation-settings:'FILL' 0,'wght' 300;">hub</span>
        </div>
        <h3 class="text-white font-bold text-lg" style="font-family:'Plus Jakarta Sans',sans-serif;">CUI_CHAT Network</h3>
      </div>

      <!-- Campus nodes mobile grid -->
      <div class="grid grid-cols-2 gap-3 w-full max-w-sm cuichat-network-reveal" style="transition-delay:0.1s;">
        <div class="cuichat-campus-node justify-center"><div class="cuichat-campus-dot-cyan"></div>Islamabad</div>
        <div class="cuichat-campus-node justify-center"><div class="cuichat-campus-dot-purple"></div>Lahore</div>
        <div class="cuichat-campus-node justify-center"><div class="cuichat-campus-dot-cyan"></div>Abbottabad</div>
        <div class="cuichat-campus-node justify-center"><div class="cuichat-campus-dot-purple"></div>Wah</div>
        <div class="cuichat-campus-node justify-center"><div class="cuichat-campus-dot-cyan"></div>Attock</div>
        <div class="cuichat-campus-node justify-center"><div class="cuichat-campus-dot-purple"></div>Vehari</div>
        <div class="cuichat-campus-node justify-center col-span-2"><div class="cuichat-campus-dot-cyan"></div>Sahiwal</div>
      </div>

    </div>

  </div>
</section>



<!--  HOW IT WORKS — Premium Dark Timeline  -->
<section class="cuichat-how-section py-24 px-6 md:px-12">

  <div class="max-w-6xl mx-auto relative z-10">

    <!-- Section header -->
    <div class="text-center mb-16 cuichat-how-reveal">
      <div class="cuichat-how-badge mb-5">Onboarding Flow</div>
      <h2 class="text-4xl md:text-5xl font-black text-white leading-tight" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        How It Works
      </h2>
      <div style="height:4px;width:80px;background:linear-gradient(90deg,#00dddd,transparent);border-radius:2px;margin:12px auto 0;"></div>
    </div>

    <!-- Timeline -->
    <div class="cuichat-how-timeline">

      <!-- Connecting line (desktop horizontal, mobile vertical) -->
      <div class="cuichat-how-line"></div>

      @php
      $steps = [
        ["1","Register",    "Sign up with your CUI email and details",    "app_registration"],
        ["2","Verify OTP",  "Phone number identity validation",            "verified_user"],
        ["3","Admin Review","Admin background check & approval",           "admin_panel_settings"],
        ["4","Approved",    "Email notification & account activated",      "check_circle"],
        ["5","Connect",     "Start networking across campuses!",           "hub"],
      ];
      @endphp

      @foreach($steps as $i => $s)
      <div class="cuichat-how-step cuichat-how-reveal" style="transition-delay:{{ $i * 0.12 }}s;">

        <!-- Number node -->
        <div class="cuichat-how-node">{{ $s[0] }}</div>

        <!-- Text -->
        <div>
          <div class="cuichat-how-step-title">{{ $s[1] }}</div>
          <div class="cuichat-how-step-desc">{{ $s[2] }}</div>
        </div>

        <!-- Connector dot (desktop only, between steps) -->
        @if($i < 4)
        <div class="cuichat-how-step-dot hidden md:block"></div>
        @endif

      </div>
      @endforeach

    </div>

  </div>
</section>



<!--  PLATFORM GOVERNANCE — Premium Dark  -->
<section class="platform-governance-section py-24 px-6 md:px-12">
  <div class="max-w-7xl mx-auto relative z-10">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">

      <!-- ── Left: Content ── -->
      <div class="flex flex-col gap-6">

        <!-- Badge -->
        <div class="governance-badge governance-reveal" style="transition-delay:0s;">
          <span class="material-symbols-outlined" style="font-size:16px;font-variation-settings:'FILL' 1;">shield</span>
          Platform Governance
        </div>

        <!-- Heading -->
        <h2 class="text-4xl md:text-5xl font-black text-white leading-tight governance-reveal" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;transition-delay:0.08s;">
          Verified Community<br>Management
        </h2>

        <!-- Paragraph -->
        <p class="text-lg leading-relaxed governance-reveal" style="color:rgba(212,227,255,0.78);font-family:'Manrope',sans-serif;transition-delay:0.14s;">
          A robust governance system ensures CUI_CHAT remains a trusted, safe, and professional academic environment for all COMSATS students and faculty.
        </p>

        <!-- Bullet list -->
        <div class="flex flex-col gap-3">
          <div class="governance-bullet governance-reveal" style="transition-delay:0.20s;">
            <div class="governance-check">
              <span class="material-symbols-outlined text-[#00dddd]" style="font-size:18px;font-variation-settings:'FILL' 1;">check</span>
            </div>
            <span class="text-white font-medium" style="font-family:'Manrope',sans-serif;">Comprehensive User Life-cycle Management</span>
          </div>
          <div class="governance-bullet governance-reveal" style="transition-delay:0.27s;">
            <div class="governance-check">
              <span class="material-symbols-outlined text-[#00dddd]" style="font-size:18px;font-variation-settings:'FILL' 1;">check</span>
            </div>
            <span class="text-white font-medium" style="font-family:'Manrope',sans-serif;">Real-time Content &amp; Community Moderation</span>
          </div>
          <div class="governance-bullet governance-reveal" style="transition-delay:0.34s;">
            <div class="governance-check">
              <span class="material-symbols-outlined text-[#00dddd]" style="font-size:18px;font-variation-settings:'FILL' 1;">check</span>
            </div>
            <span class="text-white font-medium" style="font-family:'Manrope',sans-serif;">Registration Approval &amp; Rejection Workflow</span>
          </div>
          <div class="governance-bullet governance-reveal" style="transition-delay:0.41s;">
            <div class="governance-check">
              <span class="material-symbols-outlined text-[#00dddd]" style="font-size:18px;font-variation-settings:'FILL' 1;">check</span>
            </div>
            <span class="text-white font-medium" style="font-family:'Manrope',sans-serif;">Detailed Analytics &amp; Engagement Reporting</span>
          </div>
        </div>

        <!-- CTA button -->
        <div class="governance-reveal" style="transition-delay:0.48s;">
          <a href="#features" class="governance-cta">
            <span class="material-symbols-outlined" style="font-size:18px;">explore</span>
            Discover Features
            <span class="material-symbols-outlined" style="font-size:16px;">arrow_forward</span>
          </a>
        </div>

      </div>

      <!-- ── Right: 2×2 Stat cards ── -->
      <div class="grid grid-cols-2 gap-5">

        <div class="governance-stat-card governance-reveal-right" style="transition-delay:0.10s;">
          <div class="governance-stat-number" style="background:linear-gradient(135deg,#00dddd,#00fbfb);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">15K+</div>
          <div class="governance-stat-label">Total Users</div>
        </div>

        <div class="governance-stat-card governance-reveal-right" style="transition-delay:0.20s;">
          <div class="governance-stat-number" style="background:linear-gradient(135deg,#dfb7ff,#8333c6);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">120+</div>
          <div class="governance-stat-label">Pending Requests</div>
        </div>

        <div class="governance-stat-card governance-reveal-right" style="transition-delay:0.30s;">
          <div class="governance-stat-number" style="background:linear-gradient(135deg,#b3c5ff,#435b9f);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">7</div>
          <div class="governance-stat-label">Active Campuses</div>
        </div>

        <div class="governance-stat-card governance-reveal-right" style="transition-delay:0.40s;">
          <div class="governance-stat-number" style="background:linear-gradient(135deg,#00dddd,#8333c6);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">98%</div>
          <div class="governance-stat-label">Trust Score</div>
        </div>

      </div>

    </div>
  </div>
</section>


<!--  PREMIUM FEATURES ROADMAP  -->
<section class="py-20 px-6 md:px-10 cuichat-roadmap-section" id="premium-features">
  <div class="max-w-7xl mx-auto">
    <div class="text-center mb-14 fade-in-up">
      <!-- Badge -->
      <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full mb-5"
           style="background:rgba(0,46,46,0.40);border:1px solid rgba(0,221,221,0.28);box-shadow:0 0 10px rgba(0,221,221,0.14);width:fit-content;">
        <span class="material-symbols-outlined" style="font-size:15px;color:#00dddd;font-variation-settings:'FILL' 1;">auto_awesome</span>
        <span style="font-size:11px;font-weight:700;letter-spacing:0.2em;text-transform:uppercase;color:#00dddd;font-family:'Manrope',sans-serif;">Future Roadmap</span>
      </div>
      <!-- Heading -->
      <h2 class="text-3xl md:text-4xl font-black text-white mb-4" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        <span style="background:linear-gradient(90deg,#00dddd 0%,#dfb7ff 60%,#8333c6 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">Premium Features</span> Roadmap
      </h2>
      <!-- Subtitle -->
      <p class="text-lg max-w-2xl mx-auto" style="color:rgba(212,227,255,0.72);font-family:'Manrope',sans-serif;">Future-ready capabilities planned to make CUI_CHAT a smarter university platform.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
      @php
      $roadmap = [
        ["icon"=>"videocam","title"=>"Video Calling","desc"=>"HD video calls between students and faculty within the verified network.","color"=>"text-cyan-400"],
        ["icon"=>"psychology","title"=>"AI Recommendations","desc"=>"Smart AI-based content and connection recommendations tailored to your academic profile.","color"=>"text-purple-400"],
        ["icon"=>"smart_toy","title"=>"AI Content Moderation","desc"=>"Automated AI moderation to detect and filter inappropriate content in real time.","color"=>"text-blue-400"],
        ["icon"=>"schedule","title"=>"Smart Timetable","desc"=>"Intelligent timetable and deadline reminders synced with your academic schedule.","color"=>"text-yellow-400"],
        ["icon"=>"integration_instructions","title"=>"LMS / ERP Integration","desc"=>"Seamless integration with COMSATS LMS and ERP systems for grades and attendance.","color"=>"text-green-400"],
        ["icon"=>"grading","title"=>"Attendance & Grades","desc"=>"View attendance records and grade summaries directly within CUI_CHAT.","color"=>"text-orange-400"],
        ["icon"=>"computer","title"=>"Web Version","desc"=>"Full-featured web application for desktop access to all CUI_CHAT features.","color"=>"text-cyan-300"],
        ["icon"=>"bar_chart","title"=>"Advanced Analytics","desc"=>"Deep engagement analytics for admins, faculty, and campus coordinators.","color"=>"text-pink-400"],
        ["icon"=>"offline_bolt","title"=>"Offline Feed","desc"=>"Browse cached content and compose posts even without an internet connection.","color"=>"text-amber-400"],
        ["icon"=>"speed","title"=>"CDN / Media Optimization","desc"=>"Lightning-fast media delivery via CDN for images, videos, and audio content.","color"=>"text-teal-400"],
      ];
      @endphp
      @foreach($roadmap as $r)
      <div class="roadmap-card p-6 fade-in-up">
        <div class="flex items-start justify-between mb-4">
          <span class="material-symbols-outlined text-3xl {{ $r['color'] }}">{{ $r['icon'] }}</span>
          <span class="text-xs font-bold px-2 py-1 rounded-full bg-white/10 text-white/70 border border-white/10">Roadmap</span>
        </div>
        <h3 class="text-white font-bold mb-2">{{ $r['title'] }}</h3>
        <p class="text-slate-400 text-sm leading-relaxed">{{ $r['desc'] }}</p>
      </div>
      @endforeach
    </div>
  </div>
</section>


<!--  FAQ SECTION — Premium Dark  -->
<section class="faq-section py-24 px-6 md:px-10" id="faqs">
  <div class="max-w-4xl mx-auto relative z-10">

    <!-- Header -->
    <div class="text-center mb-12 faq-reveal">
      <div class="faq-badge">FAQ's</div>
      <h2 class="text-3xl md:text-4xl font-black text-white mb-4" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        Frequently Asked <span style="background:linear-gradient(90deg,#00dddd 0%,#dfb7ff 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">Questions</span>
      </h2>
      <p class="text-lg" style="color:rgba(212,227,255,0.72);font-family:'Manrope',sans-serif;">Everything you need to know about CUI_CHAT.</p>
    </div>

    <!-- Category Pills -->
    <div class="flex flex-wrap gap-2 justify-center mb-8 faq-reveal" style="transition-delay:0.08s;" id="faqCategories">
      <button class="category-pill active" data-cat="all">All</button>
      <button class="category-pill" data-cat="about">About CUI_CHAT</button>
      <button class="category-pill" data-cat="account">Account &amp; Privacy</button>
      <button class="category-pill" data-cat="features">Features</button>
      <button class="category-pill" data-cat="campus">Campus &amp; COMSATS</button>
    </div>

    <!-- FAQ Accordion -->
    <div class="space-y-3" id="faqList">
      @php
      $faqs = [
        ["cat"=>"about","q"=>"What is CUI_CHAT?","a"=>"CUI_CHAT is a university-focused social networking platform designed for COMSATS University students and faculty. It provides a verified digital space where users can connect, communicate, share academic content, join discussions, and stay updated with campus activities."],
        ["cat"=>"about","q"=>"Why was CUI_CHAT created?","a"=>"CUI_CHAT was created to solve the problem of scattered university communication across WhatsApp groups, Facebook pages, and email threads. It brings academic communication, social interaction, announcements, and campus collaboration into one dedicated platform."],
        ["cat"=>"about","q"=>"How is CUI_CHAT different from WhatsApp?","a"=>"WhatsApp is a general messaging app, while CUI_CHAT is designed specifically for the university environment. CUI_CHAT adds student/faculty verification, campus and department identity, academic groups, content discovery, admin moderation, campus announcements, live audio rooms, and academic resource sharing."],
        ["cat"=>"about","q"=>"Who can use CUI_CHAT?","a"=>"CUI_CHAT is intended for COMSATS University students, faculty members, and platform administrators. Students and faculty can register through the app, while administrators manage approvals, moderation, and platform settings."],
        ["cat"=>"campus","q"=>"Is CUI_CHAT only for COMSATS University?","a"=>"Yes. CUI_CHAT is built around the COMSATS community and supports students and faculty from COMSATS campuses. Its goal is to create a trusted digital campus environment instead of an open, unmanaged public network."],
        ["cat"=>"account","q"=>"How can a student register on CUI_CHAT?","a"=>"A student can register by providing their full name, email, phone number, department, campus, registration number, batch duration, and password. After phone OTP verification, the account request is sent to the admin for approval."],
        ["cat"=>"account","q"=>"How can a faculty member register on CUI_CHAT?","a"=>"Faculty members can register by providing their name, email, phone number, department, campus, and password. Faculty accounts also go through verification and admin approval before access is granted."],
        ["cat"=>"account","q"=>"Why does CUI_CHAT require admin approval?","a"=>"Admin approval ensures that only genuine COMSATS students and faculty can access the platform. This helps prevent fake accounts, spam, misinformation, and outsider interference."],
        ["cat"=>"account","q"=>"Why is phone OTP verification required?","a"=>"Phone OTP verification confirms that the user owns the provided phone number. It adds an extra layer of security before the registration request is submitted for admin approval."],
        ["cat"=>"account","q"=>"Can anyone outside COMSATS join CUI_CHAT?","a"=>"No. CUI_CHAT is intended for verified COMSATS students and faculty. Registration details are reviewed before users can access the platform."],
        ["cat"=>"account","q"=>"Is my personal information visible to everyone?","a"=>"No. Sensitive details such as phone number, gender, and verification information are protected and used only for verification and administrative purposes. Public profiles show only appropriate academic and social information."],
        ["cat"=>"features","q"=>"What features does CUI_CHAT provide?","a"=>"CUI_CHAT provides verified registration, user profiles, social feed, posts, reels, stories, direct messaging, live audio rooms, push notifications, interest-based discovery, profile verification, reporting, moderation, and admin management."],
        ["cat"=>"features","q"=>"Does CUI_CHAT support direct messaging?","a"=>"Yes. CUI_CHAT supports direct messaging so students and faculty can communicate privately within the verified university network."],
        ["cat"=>"features","q"=>"What are live audio rooms in CUI_CHAT?","a"=>"Live audio rooms allow users to join real-time discussions, study sessions, society talks, FYP discussions, or faculty-led Q&A sessions."],
        ["cat"=>"features","q"=>"Can students share posts, images, videos, and academic content?","a"=>"Yes. CUI_CHAT supports a rich social feed where users can share text, images, videos, audio content, comments, and engagement-based posts."],
        ["cat"=>"campus","q"=>"Does CUI_CHAT support all COMSATS campuses?","a"=>"Yes. CUI_CHAT is designed to support Islamabad, Lahore, Abbottabad, Wah, Attock, Sahiwal, and Vehari campuses."],
        ["cat"=>"campus","q"=>"Can faculty share announcements on CUI_CHAT?","a"=>"Yes. Faculty members can use CUI_CHAT to share academic updates, class announcements, event information, and discussion topics with students."],
        ["cat"=>"campus","q"=>"Is CUI_CHAT officially integrated with COMSATS systems?","a"=>"CUI_CHAT is currently a Final Year Project and is not integrated with official university systems such as LMS, ERP, grades, or attendance. These integrations are part of future scope."],
        ["cat"=>"features","q"=>"Can CUI_CHAT be used for academic resources?","a"=>"Yes. CUI_CHAT can be enhanced with an academic resource-sharing module where students and faculty can share lecture notes, past papers, slides, and study material."],
        ["cat"=>"about","q"=>"What future features can be added?","a"=>"Future enhancements may include video calling, AI-based recommendations, AI content moderation, smart timetable reminders, LMS/ERP integration, web version, advanced analytics, offline feed, and CDN/media optimization."],
      ];
      @endphp
      @foreach($faqs as $i => $faq)
      <div class="faq-item faq-reveal" data-cat="{{ $faq['cat'] }}" style="transition-delay:{{ ($i % 8) * 0.05 }}s;">
        <button class="w-full flex items-center justify-between px-6 py-4 text-left font-semibold faq-trigger" data-index="{{ $i }}">
          <span class="pr-4 text-sm md:text-base">{{ $faq['q'] }}</span>
          <span class="material-symbols-outlined text-xl flex-shrink-0 accordion-icon">expand_more</span>
        </button>
        <div class="accordion-content px-6">
          <p class="text-sm leading-relaxed pb-4">{{ $faq['a'] }}</p>
        </div>
      </div>
      @endforeach
    </div>

  </div>
</section>



<!--  TEAM SECTION — Premium Dark  -->
<section class="builders-section py-24 px-6 md:px-12" id="team">
  <div class="max-w-6xl mx-auto relative z-10">

    <!-- Header -->
    <div class="text-center mb-16 builders-reveal">
      <div class="builders-badge">
        <span class="material-symbols-outlined" style="font-size:15px;font-variation-settings:'FILL' 1;">groups</span>
        The Builders
      </div>
      <h2 class="text-4xl md:text-5xl font-black text-white mb-4 leading-tight" style="font-family:'Plus Jakarta Sans','Manrope',sans-serif;">
        The <span style="background:linear-gradient(90deg,#00dddd 0%,#dfb7ff 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">Visionaries</span>
      </h2>
      <p class="text-lg" style="color:rgba(212,227,255,0.72);font-family:'Manrope',sans-serif;">Meet the talented team behind CUI_CHAT.</p>
    </div>

    <!-- Team cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      @php
      $team = [
        ["name"=>"M Abdullah",            "role"=>"Team Leader", "title"=>"Project Lead & Architect",    "img"=>"M Abdullah.jpeg",              "portfolio"=>"https://muhammadabdullahwali.vercel.app/",              "badge"=>"leader"],
        ["name"=>"Muhammad Haseeb Amjad", "role"=>"Developer",   "title"=>"Full Stack Developer",        "img"=>"Muhammad haseeb Amjad.png",    "portfolio"=>"https://fa-23-bse-130-6-b-advance-web.vercel.app/",    "badge"=>"developer"],
        ["name"=>"Sanawar Ali",           "role"=>"Developer",   "title"=>"Flutter & Backend Developer", "img"=>"Sanawar ali.jpeg",             "portfolio"=>"https://sanawar-portfolio.vercel.app",                 "badge"=>"developer"],
      ];
      @endphp

      @foreach($team as $i => $m)
      <div class="builder-card builders-reveal" style="transition-delay:{{ $i * 0.12 }}s;">

        <!-- Avatar with glow ring -->
        <div class="builder-avatar-wrap">
          <img src="{{ asset('asset/' . $m['img']) }}" alt="{{ $m['name'] }}" class="builder-avatar">
        </div>

        <!-- Role badge -->
        <span class="builder-role-badge {{ $m['badge'] }}">{{ $m['role'] }}</span>

        <!-- Name -->
        <div class="builder-name">{{ $m['name'] }}</div>

        <!-- Title -->
        <div class="builder-role-text">{{ $m['title'] }}</div>

        <!-- Portfolio button -->
        <a href="{{ $m['portfolio'] }}" target="_blank" rel="noopener noreferrer" class="builder-portfolio-btn">
          <span class="material-symbols-outlined" style="font-size:16px;">open_in_new</span>
          View Portfolio
        </a>

      </div>
      @endforeach
    </div>

  </div>
</section>


<!--  FOOTER — Premium Dark  -->
<div class="footer-top-divider"></div>
<footer class="footer-section py-16 px-6 md:px-12">
  <div class="max-w-7xl mx-auto relative z-10">

    <!-- 3-column grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-12 items-start">

      <!-- Column 1: Brand -->
      <div class="space-y-4 footer-reveal" style="transition-delay:0s;">
        <div class="flex items-center gap-3">
          <div class="cuichat-logo-wrap">
            <img src="{{ asset('asset/cuichat-logo.png') }}?v=20260514-logo2" alt="CUI_CHAT Logo" class="cuichat-logo-img">
          </div>
          <span class="text-xl font-black" style="background:linear-gradient(90deg,#00dddd,#dfb7ff);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-family:'Plus Jakarta Sans',sans-serif;">CUI_CHAT</span>
        </div>
        <p class="footer-description">Connecting COMSATS University Islamabad. Empowering the next generation of digital leaders through secure campus networking.</p>
        <p class="footer-powered">⚡ Powered for COMSATS University Islamabad</p>
      </div>

      <!-- Column 2: Quick Links -->
      <div class="footer-reveal" style="transition-delay:0.10s;">
        <div class="footer-heading">Quick Links</div>
        <ul class="space-y-3">
          <li><a href="#features"          class="footer-link"><span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>Features</a></li>
          <li><a href="#why-cuichat"       class="footer-link"><span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>Why CUI_CHAT</a></li>
          <li><a href="#campuses"          class="footer-link"><span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>Campuses</a></li>
          <li><a href="#faqs"              class="footer-link"><span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>FAQ's</a></li>
          <li><a href="{{ url('privacyPolicy') }}" class="footer-link"><span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>Privacy Policy</a></li>
          <li><a href="{{ url('termsOfUse') }}"    class="footer-link"><span class="material-symbols-outlined" style="font-size:14px;">chevron_right</span>Terms of Service</a></li>
        </ul>
      </div>

      <!-- Column 3: Get Started -->
      <div class="space-y-4 footer-reveal" style="transition-delay:0.20s;">
        <div class="footer-heading">Get Started</div>
        <p class="footer-description">Download the CUI_CHAT app and join the verified COMSATS community today.</p>
        <a href="#features" class="footer-cta-button">
          <span class="material-symbols-outlined" style="font-size:16px;">explore</span>
          Explore CUI_CHAT
        </a>
      </div>

    </div>

    <!-- Bottom bar -->
    <div class="footer-bottom footer-reveal" style="transition-delay:0.28s;">
      <p class="footer-copy">&copy; 2026 CUI_CHAT. Final Year Project. COMSATS University Islamabad. All Rights Reserved.</p>
      <div class="footer-campus">
        <span class="material-symbols-outlined" style="font-size:16px;">school</span>
        COMSATS University Islamabad
      </div>
    </div>

  </div>
</footer>
</main>

<script>
(function(){
  // Mobile menu toggle
  var toggle = document.getElementById("menuToggle");
  var menu = document.getElementById("mobileMenu");
  if(toggle && menu){
    toggle.addEventListener("click",function(){menu.classList.toggle("open");});
    menu.querySelectorAll("a").forEach(function(l){l.addEventListener("click",function(){menu.classList.remove("open");});});
  }
  // Mobile Why CUICHAT accordion
  var mBtn = document.getElementById("mobileWhyBtn");
  var mMenu = document.getElementById("mobileWhyMenu");
  var mIcon = document.getElementById("mobileWhyIcon");
  if(mBtn && mMenu){
    mBtn.addEventListener("click",function(){
      mMenu.classList.toggle("open");
      if(mIcon) mIcon.textContent = mMenu.classList.contains("open") ? "expand_less" : "expand_more";
    });
  }
  // FAQ accordion
  document.querySelectorAll(".faq-trigger").forEach(function(btn){
    btn.addEventListener("click",function(){
      var item = btn.closest(".faq-item");
      var content = item.querySelector(".accordion-content");
      var icon = btn.querySelector(".accordion-icon");
      var isOpen = item.classList.contains("open");
      // Close all
      document.querySelectorAll(".faq-item.open").forEach(function(o){
        o.classList.remove("open");
        o.querySelector(".accordion-content").classList.remove("open");
        var ic = o.querySelector(".accordion-icon");
        if(ic) ic.style.transform = "";
      });
      if(!isOpen){
        item.classList.add("open");
        content.classList.add("open");
        if(icon) icon.style.transform = "rotate(180deg)";
      }
    });
  });
  // FAQ category filter
  document.querySelectorAll(".category-pill").forEach(function(pill){
    pill.addEventListener("click",function(){
      document.querySelectorAll(".category-pill").forEach(function(p){p.classList.remove("active");});
      pill.classList.add("active");
      var cat = pill.getAttribute("data-cat");
      document.querySelectorAll("#faqList .faq-item").forEach(function(item){
        if(cat === "all" || item.getAttribute("data-cat") === cat){
          item.style.display = "";
        } else {
          item.style.display = "none";
        }
      });
    });
  });
  // Fade-in-up on scroll
  var observer = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.1});
  document.querySelectorAll(".fade-in-up").forEach(function(el){observer.observe(el);});
  // About section reveal (staggered)
  var aboutObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.12});
  document.querySelectorAll(".cuichat-about-reveal").forEach(function(el){aboutObserver.observe(el);});
  // Comparison section reveal (staggered)
  var compObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.08});
  document.querySelectorAll(".cuichat-comparison-reveal").forEach(function(el){compObserver.observe(el);});
  // Features section reveal (staggered)
  var featObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.08});
  document.querySelectorAll(".cuichat-features-reveal").forEach(function(el){featObserver.observe(el);});
  // How It Works reveal
  var howObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.10});
  document.querySelectorAll(".cuichat-how-reveal").forEach(function(el){howObserver.observe(el);});
  // Platform Governance reveal
  var govObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.08});
  document.querySelectorAll(".governance-reveal,.governance-reveal-right").forEach(function(el){govObserver.observe(el);});
  // FAQ reveal
  var faqRevObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.06});
  document.querySelectorAll(".faq-reveal").forEach(function(el){faqRevObserver.observe(el);});
  // Builders reveal
  var buildObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.10});
  document.querySelectorAll(".builders-reveal").forEach(function(el){buildObserver.observe(el);});
  // Footer reveal
  var footObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.05});
  document.querySelectorAll(".footer-reveal").forEach(function(el){footObserver.observe(el);});
  // Network section reveal (staggered)
  var netObserver = new IntersectionObserver(function(entries){
    entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add("visible");}});
  },{threshold:0.06});
  document.querySelectorAll(".cuichat-network-reveal").forEach(function(el){netObserver.observe(el);});
  // Network hover: activate matching SVG line + hub brightens all lines
  (function(){
    var nodes = document.querySelectorAll('[data-campus]');
    var hub   = document.getElementById('cn-hub');
    nodes.forEach(function(node){
      node.addEventListener('mouseenter', function(){
        var key  = node.getAttribute('data-campus');
        var line = document.querySelector('[data-line="'+key+'"]');
        if(line) line.classList.add('active');
      });
      node.addEventListener('mouseleave', function(){
        var key  = node.getAttribute('data-campus');
        var line = document.querySelector('[data-line="'+key+'"]');
        if(line) line.classList.remove('active');
      });
    });
    if(hub){
      hub.addEventListener('mouseenter', function(){
        document.querySelectorAll('.cuichat-network-line').forEach(function(l){l.style.opacity='0.55';});
      });
      hub.addEventListener('mouseleave', function(){
        document.querySelectorAll('.cuichat-network-line').forEach(function(l){l.style.opacity='';});
      });
    }
  })();
  // Particles canvas
  var canvas = document.getElementById("particles-canvas");
  if(canvas){
    var ctx = canvas.getContext("2d");
    var particles = [];
    function resize(){canvas.width=canvas.offsetWidth;canvas.height=canvas.offsetHeight;}
    resize();
    window.addEventListener("resize",resize);
    for(var i=0;i<80;i++){
      particles.push({
        x:Math.random()*canvas.width,y:Math.random()*canvas.height,
        r:Math.random()*2+0.5,
        vx:(Math.random()-0.5)*0.3,vy:(Math.random()-0.5)*0.3,
        alpha:Math.random()*0.6+0.2,
        color:["rgba(0,200,255,","rgba(131,51,198,","rgba(100,150,255,"][Math.floor(Math.random()*3)]
      });
    }
    function draw(){
      ctx.clearRect(0,0,canvas.width,canvas.height);
      particles.forEach(function(p){
        ctx.beginPath();
        ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
        ctx.fillStyle=p.color+p.alpha+")";
        ctx.shadowBlur=8;ctx.shadowColor=p.color+"0.8)";
        ctx.fill();
        p.x+=p.vx;p.y+=p.vy;
        if(p.x<0)p.x=canvas.width;if(p.x>canvas.width)p.x=0;
        if(p.y<0)p.y=canvas.height;if(p.y>canvas.height)p.y=0;
      });
      requestAnimationFrame(draw);
    }
    draw();
  }
  // Smooth scroll for all anchor links
  document.querySelectorAll('a[href^="#"]').forEach(function(a){
    a.addEventListener("click",function(e){
      var target = document.querySelector(a.getAttribute("href"));
      if(target){e.preventDefault();target.scrollIntoView({behavior:"smooth",block:"start"});}
    });
  });
})();
</script>
<script>
// HFB Mobile Tap Toggle
(function(){
  var badges = document.querySelectorAll('.hfb-badge');
  badges.forEach(function(badge){
    badge.addEventListener('touchstart', function(e){
      e.stopPropagation();
      var isOpen = badge.classList.contains('hfb-expanded');
      document.querySelectorAll('.hfb-badge.hfb-expanded').forEach(function(b){
        b.classList.remove('hfb-expanded');
      });
      if(!isOpen){ badge.classList.add('hfb-expanded'); }
    }, {passive:true});
  });
  document.addEventListener('touchstart', function(e){
    if(!e.target.closest('.hfb-badge')){
      document.querySelectorAll('.hfb-badge.hfb-expanded').forEach(function(b){
        b.classList.remove('hfb-expanded');
      });
    }
  }, {passive:true});
})();
</script>
</body>
</html>
