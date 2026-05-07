<!DOCTYPE html>
<html lang="en" id="home">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CUICHAT | COMSATS University Islamabad Social Platform</title>
<meta name="description" content="CUICHAT is a verified social networking platform for COMSATS University Islamabad students and faculty, connecting campuses through profiles, communities, posts, rooms, chats, events, and secure admin-approved access.">
<meta name="keywords" content="CUICHAT, COMSATS, COMSATS University Islamabad, CUI Chat, university social platform, COMSATS social network, student community, faculty platform, campus community">
<meta name="author" content="CUICHAT Team">
<meta name="robots" content="index, follow">
<link rel="canonical" href="https://cuichat.online/">
<meta name="theme-color" content="#00113a">
<link rel="icon" type="image/png" href="{{ asset('asset/landing/images/cuichat-logo.png') }}">
<link rel="shortcut icon" type="image/png" href="{{ asset('asset/landing/images/cuichat-logo.png') }}">
<link rel="apple-touch-icon" href="{{ asset('asset/landing/images/cuichat-logo.png') }}">
<meta property="og:type" content="website">
<meta property="og:url" content="https://cuichat.online/">
<meta property="og:title" content="CUICHAT | COMSATS University Islamabad Social Platform">
<meta property="og:description" content="A verified social networking platform for COMSATS students and faculty, connecting campuses through secure profiles, communities, posts, rooms, chats, events, and admin-approved access.">
<meta property="og:image" content="{{ asset('asset/landing/images/cuichat-logo.png') }}">
<meta property="og:site_name" content="CUICHAT">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="CUICHAT | COMSATS University Islamabad Social Platform">
<meta name="twitter:description" content="Connect COMSATS students and faculty across campuses through a secure, verified academic social platform.">
<meta name="twitter:image" content="{{ asset('asset/landing/images/cuichat-logo.png') }}">
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
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
.glass-card{background:rgba(255,255,255,0.75);backdrop-filter:blur(16px);border:1px solid rgba(255,255,255,0.4);}
.glass-dark{background:rgba(0,17,58,0.7);backdrop-filter:blur(16px);border:1px solid rgba(255,255,255,0.1);}
.accent-gradient{background:linear-gradient(135deg,#002366 0%,#8333c6 100%);}
.accent-gradient-text{background:linear-gradient(135deg,#002366,#8333c6);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;}
.glow-blue{box-shadow:0 0 30px rgba(0,35,102,0.2),0 0 60px rgba(0,35,102,0.1);}
.glow-purple{box-shadow:0 0 30px rgba(131,51,198,0.2),0 0 60px rgba(131,51,198,0.1);}
.glow-card{transition:all 0.3s ease;border:1px solid rgba(0,35,102,0.1);}
.glow-card:hover{transform:translateY(-6px);box-shadow:0 20px 60px rgba(0,35,102,0.15),0 0 0 1px rgba(131,51,198,0.2);border-color:rgba(131,51,198,0.3);}
.float-anim{animation:floatY 4s ease-in-out infinite;}
.float-anim-slow{animation:floatY 6s ease-in-out infinite;}
.float-anim-fast{animation:floatY 3s ease-in-out infinite;}
@keyframes floatY{0%,100%{transform:translateY(0);}50%{transform:translateY(-12px);}}
.fade-in-up{opacity:0;transform:translateY(30px);transition:opacity 0.6s ease,transform 0.6s ease;}
.fade-in-up.visible{opacity:1;transform:translateY(0);}
.nav-dropdown{display:none;position:absolute;top:calc(100% + 8px);left:50%;transform:translateX(-50%);min-width:220px;z-index:100;}
.nav-item:hover .nav-dropdown,.nav-item:focus-within .nav-dropdown{display:block;}
.mobile-menu{display:none;flex-direction:column;}
.mobile-menu.open{display:flex;}
.accordion-content{max-height:0;overflow:hidden;transition:max-height 0.4s ease,padding 0.3s ease;}
.accordion-content.open{max-height:600px;}
.accordion-icon{transition:transform 0.3s ease;}
.accordion-item.open .accordion-icon{transform:rotate(180deg);}
.phone-mockup{position:relative;width:260px;height:520px;background:linear-gradient(145deg,#1a1a2e,#16213e);border-radius:40px;border:3px solid rgba(255,255,255,0.15);box-shadow:0 40px 80px rgba(0,0,0,0.4),0 0 0 1px rgba(255,255,255,0.05),inset 0 0 0 2px rgba(255,255,255,0.05);overflow:hidden;}
.phone-notch{position:absolute;top:0;left:50%;transform:translateX(-50%);width:100px;height:28px;background:#1a1a2e;border-radius:0 0 20px 20px;z-index:10;}
.phone-screen{position:absolute;top:0;left:0;right:0;bottom:0;overflow:hidden;border-radius:38px;}
.floating-card{position:absolute;background:rgba(255,255,255,0.9);backdrop-filter:blur(12px);border:1px solid rgba(255,255,255,0.5);border-radius:16px;padding:10px 14px;box-shadow:0 8px 32px rgba(0,35,102,0.15);font-size:12px;white-space:nowrap;}
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
@media(prefers-reduced-motion:reduce){.float-anim,.float-anim-slow,.float-anim-fast{animation:none;}#particles-canvas{display:none;}.fade-in-up{opacity:1;transform:none;}}
@media(max-width:768px){.phone-mockup{width:200px;height:400px;}.floating-card{display:none;}}
</style>
</head>
<body>

<!--  NAVBAR  -->
<nav class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-xl border-b border-white/20 shadow-sm" id="navbar">
  <div class="flex items-center justify-between px-6 md:px-10 py-3 max-w-7xl mx-auto">
    <a href="#home" class="flex items-center gap-2 no-underline">
      <div class="h-10 w-10 rounded-full overflow-hidden bg-transparent shrink-0 shadow-sm">
        <img src="{{ asset('asset/cuichat-logo.png') }}" alt="CUICHAT Logo" class="h-full w-full object-cover block">
      </div>
      <span class="text-xl font-black accent-gradient-text">CUICHAT</span>
    </a>
    <div class="hidden lg:flex items-center gap-1">
      <a href="#home" class="px-3 py-2 text-sm font-semibold text-blue-900 rounded-lg hover:bg-blue-50 transition-colors no-underline">Home</a>
      <!-- Why CUICHAT Dropdown -->
      <div class="relative nav-item">
        <button class="px-3 py-2 text-sm font-semibold text-slate-600 rounded-lg hover:bg-blue-50 hover:text-blue-900 transition-colors flex items-center gap-1" id="whyBtn">
          Why CUICHAT <span class="material-symbols-outlined text-sm">expand_more</span>
        </button>
        <div class="nav-dropdown glass-card rounded-2xl shadow-2xl p-2 border border-white/50">
          <a href="#why-cuichat" class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-blue-50 transition-colors no-underline group">
            <span class="material-symbols-outlined text-primary text-xl">compare_arrows</span>
            <div><div class="text-sm font-semibold text-primary">What's Different</div><div class="text-xs text-slate-500">vs WhatsApp groups</div></div>
          </a>
          <a href="#premium-features" class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-purple-50 transition-colors no-underline group">
            <span class="material-symbols-outlined text-secondary text-xl">auto_awesome</span>
            <div><div class="text-sm font-semibold text-secondary">Premium Features</div><div class="text-xs text-slate-500">Roadmap capabilities</div></div>
          </a>
        </div>
      </div>
      <a href="#features" class="px-3 py-2 text-sm font-semibold text-slate-600 rounded-lg hover:bg-blue-50 hover:text-blue-900 transition-colors no-underline">Features</a>
      <a href="#campuses" class="px-3 py-2 text-sm font-semibold text-slate-600 rounded-lg hover:bg-blue-50 hover:text-blue-900 transition-colors no-underline">Campuses</a>
      <a href="#team" class="px-3 py-2 text-sm font-semibold text-slate-600 rounded-lg hover:bg-blue-50 hover:text-blue-900 transition-colors no-underline">Team</a>
      <a href="#faqs" class="px-3 py-2 text-sm font-semibold text-slate-600 rounded-lg hover:bg-blue-50 hover:text-blue-900 transition-colors no-underline">FAQ's</a>
      <a href="#about" class="px-3 py-2 text-sm font-semibold text-slate-600 rounded-lg hover:bg-blue-50 hover:text-blue-900 transition-colors no-underline">About</a>
    </div>
    <div class="flex items-center gap-2">
      <a href="#features" class="hidden md:inline-flex accent-gradient text-white px-5 py-2 rounded-xl text-sm font-bold hover:shadow-lg transition-all no-underline">Explore CUICHAT</a>
      <button class="lg:hidden p-2 rounded-xl hover:bg-slate-100 transition-colors" id="menuToggle">
        <span class="material-symbols-outlined text-primary">menu</span>
      </button>
    </div>
  </div>
  <!-- Mobile Menu -->
  <div class="mobile-menu px-6 pb-4 bg-white/95 backdrop-blur-xl border-t border-slate-100" id="mobileMenu">
    <a href="#home" class="py-3 text-blue-900 font-bold border-b border-slate-100 block">Home</a>
    <!-- Mobile Why CUICHAT -->
    <div class="border-b border-slate-100">
      <button class="py-3 text-slate-700 font-semibold w-full text-left flex items-center justify-between" id="mobileWhyBtn">
        Why CUICHAT <span class="material-symbols-outlined text-sm accordion-icon" id="mobileWhyIcon">expand_more</span>
      </button>
      <div class="accordion-content pl-4 space-y-1" id="mobileWhyMenu">
        <a href="#why-cuichat" class="py-2 text-sm text-slate-600 flex items-center gap-2 no-underline"><span class="material-symbols-outlined text-sm text-primary">compare_arrows</span>What's Different</a>
        <a href="#premium-features" class="py-2 text-sm text-slate-600 flex items-center gap-2 no-underline"><span class="material-symbols-outlined text-sm text-secondary">auto_awesome</span>Premium Features</a>
      </div>
    </div>
    <a href="#features" class="py-3 text-slate-600 font-medium border-b border-slate-100 block">Features</a>
    <a href="#campuses" class="py-3 text-slate-600 font-medium border-b border-slate-100 block">Campuses</a>
    <a href="#team" class="py-3 text-slate-600 font-medium border-b border-slate-100 block">Team</a>
    <a href="#faqs" class="py-3 text-slate-600 font-medium border-b border-slate-100 block">FAQ's</a>
    <a href="#about" class="py-3 text-slate-600 font-medium block">About</a>
  </div>
</nav>


<main class="pt-20">
<!--  HERO SECTION  -->
<section class="relative px-6 md:px-10 py-16 md:py-24 max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-12 items-center overflow-hidden">
  <div class="absolute -top-20 -left-20 w-96 h-96 bg-blue-500/5 rounded-full blur-3xl pointer-events-none"></div>
  <div class="absolute -bottom-20 -right-20 w-96 h-96 bg-purple-500/5 rounded-full blur-3xl pointer-events-none"></div>
  <div class="space-y-6 relative z-10">
    <span class="inline-flex items-center gap-2 text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-4 py-2 rounded-full">
      <span class="material-symbols-outlined text-sm">verified</span> Official COMSATS Social Network
    </span>
    <h1 class="text-4xl md:text-5xl lg:text-6xl font-black text-primary leading-tight tracking-tight">
      CUICHAT <br><span class="accent-gradient-text">Connect COMSATS<br>Campuses</span>
    </h1>
    <p class="text-lg text-slate-600 leading-relaxed max-w-xl">A verified digital ecosystem exclusively for COMSATS University Islamabad. Foster collaboration, spark discussions, and build meaningful networks across all seven campuses.</p>
    <div class="flex flex-wrap gap-4 pt-2">
      <a href="javascript:void(0)" class="accent-gradient text-white px-8 py-4 rounded-2xl font-bold shadow-xl shadow-primary/20 hover:shadow-primary/30 hover:shadow-primary/40 hover:-translate-y-0.5 active:scale-95 transition-all no-underline inline-flex items-center gap-2" title="Download CUICHAT App">
        <span class="material-symbols-outlined text-sm">download</span> Download App
      </a>
      <a href="#why-cuichat" class="accent-gradient text-white px-8 py-4 rounded-2xl font-bold shadow-xl shadow-secondary/20 hover:shadow-secondary/40 hover:-translate-y-0.5 active:scale-95 transition-all no-underline inline-flex items-center gap-2">
        <span class="material-symbols-outlined text-sm">compare_arrows</span> Why CUICHAT?
      </a>
    </div>
    <div class="flex items-center gap-6 pt-2">
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-green-500 text-sm">check_circle</span><span class="text-sm text-slate-600 font-medium">Verified Access</span></div>
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-blue-500 text-sm">check_circle</span><span class="text-sm text-slate-600 font-medium">Admin Approved</span></div>
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-purple-500 text-sm">check_circle</span><span class="text-sm text-slate-600 font-medium">7 Campuses</span></div>
    </div>
  </div>
  <!-- iPhone Mockup -->
  <div class="relative flex justify-center items-center min-h-[540px]">
    <!-- Glow behind phone -->
    <div class="absolute w-72 h-72 bg-gradient-to-br from-blue-500/20 to-purple-500/20 rounded-full blur-3xl"></div>
    <!-- Main Phone -->
    <div class="phone-mockup float-anim relative z-10">
      <div class="phone-notch"></div>
      <div class="phone-screen">
        <!-- Profile Cover -->
        <div class="w-full h-32 bg-gradient-to-br from-blue-900 via-blue-800 to-purple-900 relative">
          <div class="absolute inset-0 opacity-20" style="background-image:radial-gradient(circle at 30% 50%,rgba(255,255,255,0.3) 0%,transparent 60%);"></div>
        </div>
        <!-- Avatar -->
        <div class="relative px-4 pb-3" style="background:#0f172a;">
          <div class="absolute -top-8 left-4 w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-400 to-purple-500 border-3 border-slate-900 flex items-center justify-center text-white font-black text-xl" style="border:3px solid #0f172a;">H</div>
          <div class="pt-10">
            <div class="flex items-center gap-1"><span class="text-white font-bold text-sm">Muhammad Haseeb Amjad</span><span class="material-symbols-outlined text-cyan-400 text-sm">verified</span></div>
            <div class="text-slate-400 text-xs">@haseeb</div>
            <div class="flex gap-4 mt-1"><span class="text-xs text-slate-300"><span class="text-white font-bold">1</span> Followers</span><span class="text-xs text-slate-300"><span class="text-white font-bold">1</span> Following</span></div>
            <span class="inline-block mt-1 px-2 py-0.5 bg-green-600 text-white text-xs rounded-full font-bold">Software Engineering</span>
          </div>
          <!-- Tabs -->
          <div class="flex mt-3 border-b border-slate-700">
            <div class="flex-1 text-center py-2 text-xs font-bold text-white border-b-2 border-cyan-400">FEED</div>
            <div class="flex-1 text-center py-2 text-xs text-slate-500">REELS</div>
          </div>
          <!-- Post preview -->
          <div class="mt-3 bg-slate-800 rounded-xl p-3">
            <div class="flex items-center gap-2 mb-2">
              <div class="w-6 h-6 rounded-lg bg-gradient-to-br from-blue-400 to-purple-500 flex items-center justify-center text-white text-xs font-bold">H</div>
              <div><div class="text-white text-xs font-semibold">Muhammad Haseeb Amjad</div><div class="text-slate-500 text-xs">@haseeb  2d</div></div>
            </div>
            <div class="text-slate-300 text-xs leading-relaxed">Sharing knowledge with the COMSATS community  #CUICHAT #COMSATS</div>
            <div class="mt-2 h-16 bg-gradient-to-br from-blue-900 to-purple-900 rounded-lg flex items-center justify-center"><span class="material-symbols-outlined text-white/40">image</span></div>
          </div>
          <!-- Bottom Nav -->
          <div class="flex justify-around mt-3 pt-2 border-t border-slate-700">
            <div class="flex flex-col items-center gap-0.5"><span class="material-symbols-outlined text-slate-500 text-base">home</span><span class="text-slate-500 text-xs">Feed</span></div>
            <div class="flex flex-col items-center gap-0.5"><span class="material-symbols-outlined text-slate-500 text-base">groups</span><span class="text-slate-500 text-xs">Rooms</span></div>
            <div class="flex flex-col items-center gap-0.5"><span class="material-symbols-outlined text-slate-500 text-base">play_circle</span><span class="text-slate-500 text-xs">Reels</span></div>
            <div class="flex flex-col items-center gap-0.5"><span class="material-symbols-outlined text-slate-500 text-base">chat</span><span class="text-slate-500 text-xs">Chats</span></div>
            <div class="flex flex-col items-center gap-0.5"><span class="material-symbols-outlined text-cyan-400 text-base">person</span><span class="text-cyan-400 text-xs">Profile</span></div>
          </div>
        </div>
      </div>
    </div>
    <!-- Floating Cards -->
    <div class="floating-card float-anim-slow" style="top:5%;left:-10%;">
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-primary text-sm">verified_user</span><span class="text-primary font-bold text-xs">Verified Student</span></div>
    </div>
    <div class="floating-card float-anim" style="top:20%;right:-8%;">
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-green-600 text-sm">chat</span><span class="text-slate-700 font-semibold text-xs">12 new messages</span></div>
    </div>
    <div class="floating-card float-anim-fast" style="bottom:30%;left:-12%;">
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-purple-600 text-sm">groups</span><span class="text-slate-700 font-semibold text-xs">CS Study Room</span></div>
    </div>
    <div class="floating-card float-anim-slow" style="bottom:15%;right:-5%;">
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-blue-600 text-sm">school</span><span class="text-slate-700 font-semibold text-xs">Islamabad Campus</span></div>
    </div>
    <div class="floating-card float-anim" style="top:50%;left:-15%;">
      <div class="flex items-center gap-2"><span class="material-symbols-outlined text-orange-500 text-sm">notifications</span><span class="text-slate-700 font-semibold text-xs">3 notifications</span></div>
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

<!--  WHAT IS CUICHAT  -->
<section class="bg-white py-20 px-6 md:px-10" id="about">
  <div class="max-w-7xl mx-auto text-center mb-12 fade-in-up">
    <span class="inline-block text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-4 py-2 rounded-full mb-4">About the Platform</span>
    <h2 class="text-3xl md:text-4xl font-black text-primary mb-4">What is CUICHAT?</h2>
    <p class="text-lg text-slate-500 max-w-2xl mx-auto">The ultimate communication bridge for Pakistan's premier technology university.</p>
  </div>
  <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
    <div class="glass-card glow-card p-6 rounded-2xl fade-in-up">
      <div class="w-14 h-14 bg-primary/10 rounded-2xl flex items-center justify-center mb-5 text-primary"><span class="material-symbols-outlined text-3xl">hub</span></div>
      <h3 class="text-lg font-bold mb-2 text-primary">Social Networking</h3>
      <p class="text-slate-500 text-sm leading-relaxed">Build professional and social connections within your department or across campuses.</p>
    </div>
    <div class="glass-card glow-card p-6 rounded-2xl fade-in-up">
      <div class="w-14 h-14 bg-secondary/10 rounded-2xl flex items-center justify-center mb-5 text-secondary"><span class="material-symbols-outlined text-3xl">how_to_reg</span></div>
      <h3 class="text-lg font-bold mb-2 text-primary">Verified Access</h3>
      <p class="text-slate-500 text-sm leading-relaxed">Secure registration using official university credentials for a safe, closed community.</p>
    </div>
    <div class="glass-card glow-card p-6 rounded-2xl fade-in-up">
      <div class="w-14 h-14 bg-primary/10 rounded-2xl flex items-center justify-center mb-5 text-primary"><span class="material-symbols-outlined text-3xl">verified_user</span></div>
      <h3 class="text-lg font-bold mb-2 text-primary">Admin Approval</h3>
      <p class="text-slate-500 text-sm leading-relaxed">Every account is vetted by campus administrators to maintain professional standards.</p>
    </div>
    <div class="glass-card glow-card p-6 rounded-2xl fade-in-up">
      <div class="w-14 h-14 bg-secondary/10 rounded-2xl flex items-center justify-center mb-5 text-secondary"><span class="material-symbols-outlined text-3xl">diversity_3</span></div>
      <h3 class="text-lg font-bold mb-2 text-primary">Campus Community</h3>
      <p class="text-slate-500 text-sm leading-relaxed">Stay updated with campus-specific news, events, and societies tailored to your location.</p>
    </div>
  </div>
</section>

<!--  WHY CUICHAT / DIFFERENCES  -->
<section class="py-20 px-6 md:px-10 bg-slate-50" id="why-cuichat">
  <div class="max-w-7xl mx-auto">
    <div class="text-center mb-14 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-4 py-2 rounded-full mb-4">Comparison</span>
      <h2 class="text-3xl md:text-4xl font-black text-primary mb-4">Why CUICHAT?</h2>
      <p class="text-lg text-slate-500 max-w-2xl mx-auto">Why a dedicated COMSATS platform is better than scattered WhatsApp groups.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- Comparison cards data -->
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
      @foreach($comparisons as $c)
      <div class="comparison-card p-6 fade-in-up">
        <div class="flex items-center gap-3 mb-5">
          <div class="w-10 h-10 accent-gradient rounded-xl flex items-center justify-center text-white flex-shrink-0">
            <span class="material-symbols-outlined text-lg">{{ $c['icon'] }}</span>
          </div>
          <h3 class="font-bold text-primary text-base">{{ $c['title'] }}</h3>
        </div>
        <div class="grid grid-cols-2 gap-3">
          <div class="bg-red-50 rounded-xl p-3">
            <div class="flex items-center gap-1 mb-2"><span class="text-xs font-bold text-red-600 bg-red-100 px-2 py-0.5 rounded-full">WhatsApp</span></div>
            @foreach($c['wa'] as $item)
            <div class="flex items-start gap-1.5 mb-1"><span class="material-symbols-outlined text-red-400 text-xs mt-0.5">close</span><span class="text-xs text-slate-600">{{ $item }}</span></div>
            @endforeach
          </div>
          <div class="bg-blue-50 rounded-xl p-3">
            <div class="flex items-center gap-1 mb-2"><span class="text-xs font-bold text-blue-700 bg-blue-100 px-2 py-0.5 rounded-full">CUICHAT</span></div>
            @foreach($c['cui'] as $item)
            <div class="flex items-start gap-1.5 mb-1"><span class="material-symbols-outlined text-green-500 text-xs mt-0.5">check</span><span class="text-xs text-slate-600">{{ $item }}</span></div>
            @endforeach
          </div>
        </div>
      </div>
      @endforeach
    </div>
  </div>
</section>


<!--  CORE FEATURES  -->
<section class="py-20 px-6 md:px-10 bg-white" id="features">
  <div class="max-w-7xl mx-auto">
    <div class="mb-12 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-4 py-2 rounded-full mb-4">Platform Features</span>
      <h2 class="text-3xl md:text-4xl font-black text-primary">Core Platform Features</h2>
      <div class="h-1 w-20 accent-gradient mt-3 rounded-full"></div>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      @php
      $features = [
        ["icon"=>"account_circle","title"=>"Profiles","desc"=>"Comprehensive student and faculty profiles highlighting skills, research, and campus status."],
        ["icon"=>"language","title"=>"Connectivity","desc"=>"Seamless real-time messaging and collaborative groups across all COMSATS locations."],
        ["icon"=>"fact_check","title"=>"Registration Approval","desc"=>"Automated vetting combined with manual admin oversight for ironclad platform security."],
        ["icon"=>"interests","title"=>"Interests","desc"=>"Algorithm-based suggestions to connect you with peers who share your academic passions."],
        ["icon"=>"dynamic_feed","title"=>"Posts & Reels","desc"=>"Share campus life moments and academic breakthroughs through rich media feeds and short clips."],
        ["icon"=>"mic","title"=>"Live Audio Rooms","desc"=>"Join real-time study sessions, FYP discussions, and faculty-led Q&A sessions."],
        ["icon"=>"gavel","title"=>"Moderation","desc"=>"Advanced moderation tools ensure the platform remains a safe space for professional growth."],
        ["icon"=>"notifications","title"=>"Push Notifications","desc"=>"Stay updated with campus announcements, messages, and activity alerts in real time."],
        ["icon"=>"auto_stories","title"=>"Stories","desc"=>"Share 24-hour campus moments and updates with your university network."],
      ];
      @endphp
      @foreach($features as $f)
      <div class="p-6 rounded-2xl border border-outline-variant hover:border-secondary transition-all group relative overflow-hidden bg-white glow-card fade-in-up">
        <span class="material-symbols-outlined text-4xl text-primary mb-4 block group-hover:scale-110 transition-transform">{{ $f['icon'] }}</span>
        <h3 class="text-lg font-bold mb-2">{{ $f['title'] }}</h3>
        <p class="text-slate-500 text-sm leading-relaxed">{{ $f['desc'] }}</p>
        <div class="absolute -right-4 -bottom-4 opacity-5 group-hover:opacity-10 transition-opacity pointer-events-none">
          <span class="material-symbols-outlined text-8xl">{{ $f['icon'] }}</span>
        </div>
      </div>
      @endforeach
    </div>
  </div>
</section>

<!--  CAMPUSES  -->
<section class="bg-primary py-20 px-6 md:px-10 relative overflow-hidden" id="campuses">
  <div class="absolute inset-0 opacity-5 pointer-events-none" style="background-image:radial-gradient(circle at 20% 50%,rgba(255,255,255,0.3) 0%,transparent 50%),radial-gradient(circle at 80% 50%,rgba(131,51,198,0.3) 0%,transparent 50%);"></div>
  <div class="max-w-7xl mx-auto relative z-10">
    <div class="text-center mb-12 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-cyan-400 mb-4">Network Coverage</span>
      <h2 class="text-3xl md:text-4xl font-black text-white mb-3">Unified COMSATS Network</h2>
      <p class="text-blue-200 text-lg">Connecting seven vibrant campuses into one digital family.</p>
    </div>
    <div class="flex flex-wrap justify-center gap-4">
      @foreach(['Islamabad','Lahore','Abbottabad','Wah','Attock','Vehari','Sahiwal'] as $campus)
      <div class="bg-white/10 backdrop-blur-md px-8 py-4 rounded-full border border-white/20 text-white font-bold hover:bg-white/20 transition-all cursor-default hover:scale-105 hover:shadow-lg hover:shadow-white/10">{{ $campus }}</div>
      @endforeach
    </div>
  </div>
</section>

<!--  HOW IT WORKS  -->
<section class="py-20 px-6 md:px-10 bg-white">
  <div class="max-w-7xl mx-auto">
    <div class="text-center mb-16 fade-in-up">
      <h2 class="text-3xl md:text-4xl font-black text-primary">How It Works</h2>
    </div>
    <div class="relative flex flex-col md:flex-row justify-between items-start md:items-center gap-8 md:gap-4">
      <div class="absolute top-8 left-0 w-full h-0.5 bg-gradient-to-r from-primary/20 via-secondary/20 to-primary/20 hidden md:block -z-10"></div>
      @php $steps=[["1","Register","Sign up with your CUI email and details"],["2","Verify OTP","Phone number identity validation"],["3","Admin Review","Admin background check & approval"],["4","Approved","Email notification & account activated"],["5","Connect","Start networking across campuses!"]]; @endphp
      @foreach($steps as $s)
      <div class="flex flex-col items-center text-center space-y-3 group fade-in-up flex-1">
        <div class="w-16 h-16 rounded-full bg-white border-4 border-primary/20 text-primary flex items-center justify-center font-black text-xl group-hover:accent-gradient group-hover:text-white group-hover:border-transparent transition-all duration-300 shadow-md">{{ $s[0] }}</div>
        <h4 class="font-bold text-primary text-sm">{{ $s[1] }}</h4>
        <p class="text-xs text-slate-500 max-w-[120px]">{{ $s[2] }}</p>
      </div>
      @endforeach
    </div>
  </div>
</section>


<!--  PLATFORM GOVERNANCE (renamed from Admin Control)  -->
<section class="bg-slate-900 py-20 px-6 md:px-10 text-white">
  <div class="max-w-7xl mx-auto flex flex-col lg:flex-row items-center gap-12">
    <div class="flex-1 space-y-6 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-cyan-400 bg-cyan-400/10 px-4 py-2 rounded-full">Platform Governance</span>
      <h2 class="text-3xl md:text-4xl font-bold">Verified Community Management</h2>
      <p class="text-lg text-slate-400 leading-relaxed">A robust governance system ensures CUICHAT remains a trusted, safe, and professional academic environment for all COMSATS students and faculty.</p>
      <ul class="space-y-4">
        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-cyan-400">check_circle</span><span>Comprehensive User Life-cycle Management</span></li>
        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-cyan-400">check_circle</span><span>Real-time Content &amp; Community Moderation</span></li>
        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-cyan-400">check_circle</span><span>Registration Approval &amp; Rejection Workflow</span></li>
        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-cyan-400">check_circle</span><span>Detailed Analytics &amp; Engagement Reporting</span></li>
      </ul>
      <a href="#features" class="inline-flex items-center gap-2 bg-cyan-500 hover:bg-cyan-400 text-slate-900 px-8 py-3 rounded-xl font-bold transition-all no-underline">
        <span class="material-symbols-outlined text-sm">explore</span> Discover Features
      </a>
    </div>
    <div class="flex-1 grid grid-cols-2 gap-4 w-full max-w-sm lg:max-w-none fade-in-up">
      <div class="bg-white/5 border border-white/10 p-6 rounded-2xl text-center hover:bg-white/10 transition-colors"><span class="text-4xl font-black text-cyan-400">15K+</span><div class="text-slate-400 text-xs font-bold tracking-widest uppercase mt-2">Total Users</div></div>
      <div class="bg-white/5 border border-white/10 p-6 rounded-2xl text-center hover:bg-white/10 transition-colors"><span class="text-4xl font-black text-purple-400">120+</span><div class="text-slate-400 text-xs font-bold tracking-widest uppercase mt-2">Pending Requests</div></div>
      <div class="bg-white/5 border border-white/10 p-6 rounded-2xl text-center hover:bg-white/10 transition-colors"><span class="text-4xl font-black text-blue-400">7</span><div class="text-slate-400 text-xs font-bold tracking-widest uppercase mt-2">Active Campuses</div></div>
      <div class="bg-white/5 border border-white/10 p-6 rounded-2xl text-center hover:bg-white/10 transition-colors"><span class="text-4xl font-black text-emerald-400">98%</span><div class="text-slate-400 text-xs font-bold tracking-widest uppercase mt-2">Trust Score</div></div>
    </div>
  </div>
</section>

<!--  PREMIUM FEATURES ROADMAP  -->
<section class="py-20 px-6 md:px-10 bg-slate-950" id="premium-features">
  <div class="max-w-7xl mx-auto">
    <div class="text-center mb-14 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-purple-400 bg-purple-400/10 px-4 py-2 rounded-full mb-4">Future Roadmap</span>
      <h2 class="text-3xl md:text-4xl font-black text-white mb-4">Premium Features Roadmap</h2>
      <p class="text-slate-400 text-lg max-w-2xl mx-auto">Future-ready capabilities planned to make CUICHAT a smarter university platform.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
      @php
      $roadmap = [
        ["icon"=>"videocam","title"=>"Video Calling","desc"=>"HD video calls between students and faculty within the verified network.","color"=>"text-cyan-400"],
        ["icon"=>"psychology","title"=>"AI Recommendations","desc"=>"Smart AI-based content and connection recommendations tailored to your academic profile.","color"=>"text-purple-400"],
        ["icon"=>"smart_toy","title"=>"AI Content Moderation","desc"=>"Automated AI moderation to detect and filter inappropriate content in real time.","color"=>"text-blue-400"],
        ["icon"=>"schedule","title"=>"Smart Timetable","desc"=>"Intelligent timetable and deadline reminders synced with your academic schedule.","color"=>"text-yellow-400"],
        ["icon"=>"integration_instructions","title"=>"LMS / ERP Integration","desc"=>"Seamless integration with COMSATS LMS and ERP systems for grades and attendance.","color"=>"text-green-400"],
        ["icon"=>"grading","title"=>"Attendance & Grades","desc"=>"View attendance records and grade summaries directly within CUICHAT.","color"=>"text-orange-400"],
        ["icon"=>"computer","title"=>"Web Version","desc"=>"Full-featured web application for desktop access to all CUICHAT features.","color"=>"text-cyan-300"],
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


<!--  FAQ SECTION  -->
<section class="py-20 px-6 md:px-10 bg-white" id="faqs">
  <div class="max-w-4xl mx-auto">
    <div class="text-center mb-12 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-4 py-2 rounded-full mb-4">FAQ's</span>
      <h2 class="text-3xl md:text-4xl font-black text-primary mb-4">Frequently Asked Questions</h2>
      <p class="text-slate-500 text-lg">Everything you need to know about CUICHAT.</p>
    </div>
    <!-- Category Pills -->
    <div class="flex flex-wrap gap-2 justify-center mb-8 fade-in-up" id="faqCategories">
      <button class="category-pill active" data-cat="all">All</button>
      <button class="category-pill" data-cat="about">About CUICHAT</button>
      <button class="category-pill" data-cat="account">Account & Privacy</button>
      <button class="category-pill" data-cat="features">Features</button>
      <button class="category-pill" data-cat="campus">Campus & COMSATS</button>
    </div>
    <!-- FAQ Accordion -->
    <div class="space-y-3" id="faqList">
      @php
      $faqs = [
        ["cat"=>"about","q"=>"What is CUICHAT?","a"=>"CUICHAT is a university-focused social networking platform designed for COMSATS University students and faculty. It provides a verified digital space where users can connect, communicate, share academic content, join discussions, and stay updated with campus activities."],
        ["cat"=>"about","q"=>"Why was CUICHAT created?","a"=>"CUICHAT was created to solve the problem of scattered university communication across WhatsApp groups, Facebook pages, and email threads. It brings academic communication, social interaction, announcements, and campus collaboration into one dedicated platform."],
        ["cat"=>"about","q"=>"How is CUICHAT different from WhatsApp?","a"=>"WhatsApp is a general messaging app, while CUICHAT is designed specifically for the university environment. CUICHAT adds student/faculty verification, campus and department identity, academic groups, content discovery, admin moderation, campus announcements, live audio rooms, and academic resource sharing."],
        ["cat"=>"about","q"=>"Who can use CUICHAT?","a"=>"CUICHAT is intended for COMSATS University students, faculty members, and platform administrators. Students and faculty can register through the app, while administrators manage approvals, moderation, and platform settings."],
        ["cat"=>"campus","q"=>"Is CUICHAT only for COMSATS University?","a"=>"Yes. CUICHAT is built around the COMSATS community and supports students and faculty from COMSATS campuses. Its goal is to create a trusted digital campus environment instead of an open, unmanaged public network."],
        ["cat"=>"account","q"=>"How can a student register on CUICHAT?","a"=>"A student can register by providing their full name, email, phone number, department, campus, registration number, batch duration, and password. After phone OTP verification, the account request is sent to the admin for approval."],
        ["cat"=>"account","q"=>"How can a faculty member register on CUICHAT?","a"=>"Faculty members can register by providing their name, email, phone number, department, campus, and password. Faculty accounts also go through verification and admin approval before access is granted."],
        ["cat"=>"account","q"=>"Why does CUICHAT require admin approval?","a"=>"Admin approval ensures that only genuine COMSATS students and faculty can access the platform. This helps prevent fake accounts, spam, misinformation, and outsider interference."],
        ["cat"=>"account","q"=>"Why is phone OTP verification required?","a"=>"Phone OTP verification confirms that the user owns the provided phone number. It adds an extra layer of security before the registration request is submitted for admin approval."],
        ["cat"=>"account","q"=>"Can anyone outside COMSATS join CUICHAT?","a"=>"No. CUICHAT is intended for verified COMSATS students and faculty. Registration details are reviewed before users can access the platform."],
        ["cat"=>"account","q"=>"Is my personal information visible to everyone?","a"=>"No. Sensitive details such as phone number, gender, and verification information are protected and used only for verification and administrative purposes. Public profiles show only appropriate academic and social information."],
        ["cat"=>"features","q"=>"What features does CUICHAT provide?","a"=>"CUICHAT provides verified registration, user profiles, social feed, posts, reels, stories, direct messaging, live audio rooms, push notifications, interest-based discovery, profile verification, reporting, moderation, and admin management."],
        ["cat"=>"features","q"=>"Does CUICHAT support direct messaging?","a"=>"Yes. CUICHAT supports direct messaging so students and faculty can communicate privately within the verified university network."],
        ["cat"=>"features","q"=>"What are live audio rooms in CUICHAT?","a"=>"Live audio rooms allow users to join real-time discussions, study sessions, society talks, FYP discussions, or faculty-led Q&A sessions."],
        ["cat"=>"features","q"=>"Can students share posts, images, videos, and academic content?","a"=>"Yes. CUICHAT supports a rich social feed where users can share text, images, videos, audio content, comments, and engagement-based posts."],
        ["cat"=>"campus","q"=>"Does CUICHAT support all COMSATS campuses?","a"=>"Yes. CUICHAT is designed to support Islamabad, Lahore, Abbottabad, Wah, Attock, Sahiwal, and Vehari campuses."],
        ["cat"=>"campus","q"=>"Can faculty share announcements on CUICHAT?","a"=>"Yes. Faculty members can use CUICHAT to share academic updates, class announcements, event information, and discussion topics with students."],
        ["cat"=>"campus","q"=>"Is CUICHAT officially integrated with COMSATS systems?","a"=>"CUICHAT is currently a Final Year Project and is not integrated with official university systems such as LMS, ERP, grades, or attendance. These integrations are part of future scope."],
        ["cat"=>"features","q"=>"Can CUICHAT be used for academic resources?","a"=>"Yes. CUICHAT can be enhanced with an academic resource-sharing module where students and faculty can share lecture notes, past papers, slides, and study material."],
        ["cat"=>"about","q"=>"What future features can be added?","a"=>"Future enhancements may include video calling, AI-based recommendations, AI content moderation, smart timetable reminders, LMS/ERP integration, web version, advanced analytics, offline feed, and CDN/media optimization."],
      ];
      @endphp
      @foreach($faqs as $i => $faq)
      <div class="faq-item" data-cat="{{ $faq['cat'] }}">
        <button class="w-full flex items-center justify-between px-6 py-4 text-left font-semibold text-primary hover:text-secondary transition-colors faq-trigger" data-index="{{ $i }}">
          <span class="pr-4 text-sm md:text-base">{{ $faq['q'] }}</span>
          <span class="material-symbols-outlined text-xl flex-shrink-0 accordion-icon text-slate-400">expand_more</span>
        </button>
        <div class="accordion-content px-6">
          <p class="text-slate-600 text-sm leading-relaxed pb-4">{{ $faq['a'] }}</p>
        </div>
      </div>
      @endforeach
    </div>
  </div>
</section>


<!--  TEAM SECTION  -->
<section class="py-20 px-6 md:px-10 bg-slate-50" id="team">
  <div class="max-w-7xl mx-auto">
    <div class="text-center mb-12 fade-in-up">
      <span class="inline-block text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-4 py-2 rounded-full mb-4">The Builders</span>
      <h2 class="text-3xl md:text-4xl font-black text-primary mb-3">The Visionaries</h2>
      <p class="text-slate-500 text-lg">Meet the talented team behind CUICHAT.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      @php
      $team = [
        ["name"=>"M Abdullah","role"=>"Team Leader","title"=>"Project Lead & Architect","initial"=>"A","color"=>"from-blue-500 to-blue-700","portfolio"=>"https://muhammadabdullahwali.vercel.app/"],
        ["name"=>"Muhammad Haseeb Amjad","role"=>"Developer","title"=>"Full Stack Developer","initial"=>"H","color"=>"from-purple-500 to-purple-700","portfolio"=>"https://fa-23-bse-130-6-b-advance-web.vercel.app/"],
        ["name"=>"Sanawar Ali","role"=>"Developer","title"=>"Flutter & Backend Developer","initial"=>"S","color"=>"from-cyan-500 to-blue-600","portfolio"=>"https://sanawar-portfolio.vercel.app"],
      ];
      @endphp
      @foreach($team as $m)
      <div class="glass-card rounded-3xl p-8 text-center flex flex-col items-center hover:-translate-y-3 transition-all duration-300 shadow-lg hover:shadow-2xl hover:shadow-primary/10 fade-in-up">
        <img src="{{ asset('asset/' . ($m['name'] === 'M Abdullah' ? 'M Abdullah.jpeg' : ($m['name'] === 'Muhammad Haseeb Amjad' ? 'Muhammad haseeb Amjad.png' : 'Sanawar ali.jpeg'))) }}" alt="{{ $m['name'] }}" class="w-24 h-24 rounded-2xl object-cover mb-5 shadow-lg">
        <span class="text-xs font-bold tracking-widest uppercase text-secondary bg-secondary/10 px-3 py-1 rounded-full mb-3">{{ $m['role'] }}</span>
        <h3 class="text-lg font-bold text-primary mb-1">{{ $m['name'] }}</h3>
        <p class="text-slate-500 text-sm mb-6">{{ $m['title'] }}</p>
        <a href="{{ $m['portfolio'] }}" target="_blank" rel="noopener noreferrer" class="inline-flex items-center gap-2 accent-gradient text-white px-6 py-2.5 rounded-xl font-bold text-sm hover:shadow-lg hover:shadow-primary/20 transition-all no-underline">
          <span class="material-symbols-outlined text-sm">open_in_new</span> View Portfolio
        </a>
      </div>
      @endforeach
    </div>
  </div>
</section>

<!--  FOOTER  -->
<footer class="bg-slate-950 text-white py-16 px-6 md:px-10">
  <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-10 items-start">
    <div class="space-y-4">
      <div class="flex items-center gap-3">
        <div class="h-10 w-10 rounded-full overflow-hidden bg-transparent shrink-0 shadow-sm">
          <img src="{{ asset('asset/cuichat-logo.png') }}" alt="CUICHAT Logo" class="h-full w-full object-cover block">
        </div>
        <span class="text-xl font-black accent-gradient-text">CUICHAT</span>
      </div>
      <p class="text-slate-400 text-sm leading-relaxed">Connecting COMSATS University Islamabad. Empowering the next generation of digital leaders through secure campus networking.</p>
      <p class="font-bold text-blue-400 text-sm">Powered for COMSATS University Islamabad</p>
    </div>
    <div class="space-y-4">
      <h4 class="font-bold text-white">Quick Links</h4>
      <ul class="space-y-2">
        <li><a href="#features" class="text-slate-400 hover:text-white transition-colors text-sm no-underline">Features</a></li>
        <li><a href="#why-cuichat" class="text-slate-400 hover:text-white transition-colors text-sm no-underline">Why CUICHAT</a></li>
        <li><a href="#campuses" class="text-slate-400 hover:text-white transition-colors text-sm no-underline">Campuses</a></li>
        <li><a href="#faqs" class="text-slate-400 hover:text-white transition-colors text-sm no-underline">FAQ's</a></li>
        <li><a href="{{ url('privacyPolicy') }}" class="text-slate-400 hover:text-white transition-colors text-sm no-underline">Privacy Policy</a></li>
        <li><a href="{{ url('termsOfUse') }}" class="text-slate-400 hover:text-white transition-colors text-sm no-underline">Terms of Service</a></li>
      </ul>
    </div>
    <div class="space-y-4">
      <h4 class="font-bold text-white">Get Started</h4>
      <p class="text-slate-400 text-sm">Download the CUICHAT app and join the verified COMSATS community today.</p>
      <a href="#features" class="inline-flex items-center gap-2 accent-gradient text-white px-6 py-3 rounded-xl font-bold text-sm hover:shadow-lg transition-all no-underline">
        <span class="material-symbols-outlined text-sm">explore</span> Explore CUICHAT
      </a>
    </div>
  </div>
  <div class="max-w-7xl mx-auto mt-12 pt-8 border-t border-slate-800 flex flex-col md:flex-row justify-between items-center gap-4 text-slate-500 text-sm">
    <p>&copy; 2026 CUICHAT. Final Year Project. COMSATS University Islamabad. All Rights Reserved.</p>
    <div class="flex items-center gap-2"><span class="material-symbols-outlined text-base text-blue-400">school</span><span class="font-medium text-blue-400">COMSATS University Islamabad</span></div>
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
</body>
</html>
