<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>ماين كرافت هب</title>
<link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700;900&display=swap" rel="stylesheet">
<style>
:root{--bg:#f2f5ee;--card:#fff;--tx:#1c2a1a;--mut:#5d6b59;--ac:#3f9b2f;--ac2:#2c6f21;--bd:#d6e0d0;--dng:#c0392b;box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px);color-scheme:light}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#11160f;--card:#1b2418;--tx:#e8f0e4;--mut:#9fb199;--ac:#5fc94a;--ac2:#3f9b2f;--bd:#2c3a28;color-scheme:dark}}
:root[data-theme="dark"]{--bg:#11160f;--card:#1b2418;--tx:#e8f0e4;--mut:#9fb199;--ac:#5fc94a;--ac2:#3f9b2f;--bd:#2c3a28;color-scheme:dark}
html{scroll-padding-top:env(safe-area-inset-top,0px)}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--tx);font-family:'Cairo',system-ui,sans-serif;min-height:100vh}
header{background:linear-gradient(135deg,#2c6f21,#3f9b2f 60%,#7bd35f);color:#fff;padding:22px 16px 18px;position:relative}
.top{max-width:900px;margin:auto;display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap}
h1{margin:0;font-size:26px;font-weight:900}
.sub{opacity:.9;font-size:13px}
button,input,textarea,select{font-family:inherit;font-size:15px}
.btn{background:var(--ac);color:#fff;border:0;border-radius:10px;padding:9px 16px;cursor:pointer;font-weight:700}
.btn:hover{background:var(--ac2)}
.btn.ghost{background:rgba(255,255,255,.2)}
.btn.sec{background:transparent;border:1px solid var(--bd);color:var(--tx)}
.btn.dng{background:var(--dng)}
main{max-width:900px;margin:auto;padding:16px}
.tabs{display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:8px;margin-bottom:16px}
.tab{background:var(--card);border:2px solid var(--bd);border-radius:12px;padding:12px 6px;text-align:center;cursor:pointer;font-weight:700;color:var(--tx)}
.tab small{display:block;font-weight:400;color:var(--mut);font-size:11px}
.tab.on{border-color:var(--ac);background:var(--ac);color:#fff}.tab.on small{color:#e6ffe0}
.card{background:var(--card);border:1px solid var(--bd);border-radius:14px;padding:14px;margin-bottom:12px}
.item{display:flex;justify-content:space-between;gap:10px;align-items:center;flex-wrap:wrap}
.item h3{margin:0 0 4px;font-size:17px}.item p{margin:0;color:var(--mut);font-size:13px;white-space:pre-wrap}
.badge{font-size:11px;background:var(--bd);border-radius:6px;padding:2px 7px;color:var(--mut)}
.empty{text-align:center;color:var(--mut);padding:30px}
input,textarea,select{width:100%;padding:10px;border-radius:10px;border:1px solid var(--bd);background:var(--bg);color:var(--tx);margin:5px 0}
label{font-size:13px;color:var(--mut)}
.modal{position:fixed;inset:0;background:rgba(0,0,0,.55);display:none;align-items:center;justify-content:center;padding:16px;z-index:20}
.modal.show{display:flex}
.box{background:var(--card);border-radius:16px;padding:18px;width:100%;max-width:420px;max-height:90vh;overflow:auto}
.row{display:flex;gap:8px}.row>*{flex:1}
.seg{display:flex;gap:6px;margin:6px 0}.seg button{flex:1}
footer{text-align:center;padding:24px 12px;color:var(--mut);font-size:14px}
footer b{color:var(--ac)}
.err{color:var(--dng);font-size:13px;min-height:18px}
</style>
</head>
<body>
<header><div class="top">
<div><h1>⛏️ ماين كرافت هب</h1><div class="sub">مودات • ريسورس باكات • عوالم • هاكات</div></div>
<div style="display:flex;gap:8px;align-items:center">
<span id="who" class="sub"></span>
<button class="btn ghost" id="authBtn">تسجيل الدخول</button>
</div></div></header>

<main>
<div class="tabs" id="tabs"></div>
<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px">
<h2 id="secTitle" style="margin:0;font-size:19px"></h2>
<button class="btn" id="addBtn" style="display:none">➕ إضافة</button>
</div>
<div id="list"></div>
</main>

<footer>© جميع الحقوق محفوظة لـ <b>شادي</b><br>تيك توك: <b>@shade015</b></footer>

<div class="modal" id="mAuth"><div class="box">
<div class="seg"><button class="btn" id="tLogin">دخول</button><button class="btn sec" id="tSign">إنشاء حساب</button></div>
<label>اسم المستخدم</label><input id="u" autocomplete="username">
<label>كلمة المرور</label><input id="p" type="password" autocomplete="current-password">
<div class="err" id="aErr"></div>
<div class="row"><button class="btn" id="aGo">دخول</button><button class="btn sec" data-close>إغلاق</button></div>
</div></div>

<div class="modal" id="mAdd"><div class="box">
<h3 style="margin-top:0">إضافة جديد</h3>
<label>القسم</label><select id="cat"></select>
<label>العنوان</label><input id="t">
<label>الوصف</label><textarea id="d" rows="3"></textarea>
<label>طريقة الإضافة</label>
<div class="seg"><button class="btn" id="mFile">📁 ملف</button><button class="btn sec" id="mLink">🔗 رابط</button></div>
<div id="fileBox"><input type="file" id="f"></div>
<div id="linkBox" style="display:none"><input id="l" placeholder="https://..." dir="ltr"></div>
<div class="err" id="eErr"></div>
<div class="row"><button class="btn" id="eGo">نشر</button><button class="btn sec" data-close>إلغاء</button></div>
</div></div>

<script>
const CATS=[
 {id:'mods_be',n:'المودات',s:'بيدروك'},
 {id:'mods_java',n:'المودات',s:'جافا'},
 {id:'rp_be',n:'الريسورس باكات',s:'بيدروك'},
 {id:'rp_java',n:'الريسورس باكات',s:'جافا'},
 {id:'worlds',n:'العوالم',s:'Worlds'},
 {id:'hacks',n:'الهاكات',s:'Hacks'}];
let cur=CATS[0].id,items=[],db=null,assets=null,downloads=null,me=null,isAdmin=false,mode='file';
const $=id=>document.getElementById(id);
const ls={get(k){try{return localStorage.getItem(k)}catch(e){return null}},set(k,v){try{localStorage.setItem(k,v)}catch(e){}},del(k){try{localStorage.removeItem(k)}catch(e){}}};
me=ls.get('mc_user');

function tabs(){
 $('tabs').innerHTML='';
 CATS.forEach(c=>{const b=document.createElement('div');b.className='tab'+(c.id===cur?' on':'');
  b.innerHTML=c.n+'<small>'+c.s+'</small>';b.onclick=()=>{cur=c.id;tabs();render()};$('tabs').appendChild(b)});
 const c=CATS.find(x=>x.id===cur);$('secTitle').textContent=c.n+' ('+c.s+')';
}
function render(){
 const L=$('list');L.innerHTML='';
 const arr=items.filter(i=>i.cat===cur).sort((a,b)=>b.ts-a.ts);
 if(!arr.length){L.innerHTML='<div class="empty">لا يوجد محتوى بعد في هذا القسم</div>';return}
 arr.forEach(i=>{
  const d=document.createElement('div');d.className='card item';
  const info=document.createElement('div');
  const h=document.createElement('h3');h.textContent=i.title;
  const p=document.createElement('p');p.textContent=i.desc||'';
  const bd=document.createElement('span');bd.className='badge';bd.textContent=i.type==='file'?'ملف':'رابط';
  info.append(h,p,bd);
  const act=document.createElement('div');act.style.display='flex';act.style.gap='6px';
  const g=document.createElement('button');g.className='btn';g.textContent='⬇️ تحميل';g.onclick=()=>get(i);act.appendChild(g);
  if(isAdmin){const x=document.createElement('button');x.className='btn dng';x.textContent='🗑️';x.onclick=()=>del(i);act.appendChild(x)}
  d.append(info,act);L.appendChild(d)});
}
async function get(i){
 if(i.type==='link'){window.open(i.ref,'_blank','noopener');return}
 try{
  const r=await fetch('/_blob/'+i.ref);const b=await r.blob();
  if(downloads){await downloads.save({filename:i.fname||i.title,data:b})}else window.open('/_blob/'+i.ref,'_blank');
 }catch(e){alert('تعذر التحميل')}
}
async function del(i){
 if(!confirm('حذف "'+i.title+'"؟'))return;
 try{await db.doc('items/'+i.id).delete();if(i.type==='file'&&assets)assets.delete(i.ref).catch(()=>{})}catch(e){alert('فشل الحذف')}
}
function ui(){
 $('who').textContent=me?('👤 '+me+(isAdmin?' (مشرف)':'')):'';
 $('authBtn').textContent=me?'تسجيل الخروج':'تسجيل الدخول';
 $('addBtn').style.display=isAdmin?'':'none';
 render();
}
async function sha(s){const b=await crypto.subtle.digest('SHA-256',new TextEncoder().encode(s));return [...new Uint8Array(b)].map(x=>x.toString(16).padStart(2,'0')).join('')}

// Auth
let authMode='login';
function setAuth(m){authMode=m;$('tLogin').className='btn'+(m==='login'?'':' sec');$('tSign').className='btn'+(m==='sign'?'':' sec');$('aGo').textContent=m==='login'?'دخول':'إنشاء حساب';$('aErr').textContent=''}
$('tLogin').onclick=()=>setAuth('login');$('tSign').onclick=()=>setAuth('sign');
$('authBtn').onclick=()=>{if(me){me=null;ls.del('mc_user');ui()}else{setAuth('login');$('mAuth').classList.add('show')}};
$('aGo').onclick=async()=>{
 const u=$('u').value.trim().toLowerCase(),p=$('p').value;$('aErr').textContent='';
 if(!/^[a-z0-9_]{3,20}$/.test(u))return $('aErr').textContent='اسم المستخدم: 3-20 حرف إنجليزي/أرقام/_';
 if(p.length<6)return $('aErr').textContent='كلمة المرور 6 أحرف على الأقل';
 if(!db)return $('aErr').textContent='الخدمة غير متاحة حالياً';
 try{
  const ref=db.doc('accounts/'+u);const snap=await ref.get();
  const ex=snap&&(snap.exists===true||(typeof snap.exists==='function'&&snap.exists()));
  const data=ex?(typeof snap.data==='function'?snap.data():snap.data):null;
  if(authMode==='sign'){
   if(data)return $('aErr').textContent='اسم المستخدم مستخدم';
   const salt=crypto.randomUUID();await ref.set({salt,hash:await sha(salt+p),ts:Date.now()});
  }else{
   if(!data||data.hash!==await sha(data.salt+p))return $('aErr').textContent='بيانات الدخول غير صحيحة';
  }
  me=u;ls.set('mc_user',u);$('mAuth').classList.remove('show');$('u').value=$('p').value='';ui();
 }catch(e){$('aErr').textContent='حدث خطأ، حاول مرة أخرى'}
};

// Add
function setMode(m){mode=m;$('fileBox').style.display=m==='file'?'':'none';$('linkBox').style.display=m==='link'?'':'none';$('mFile').className='btn'+(m==='file'?'':' sec');$('mLink').className='btn'+(m==='link'?'':' sec')}
$('mFile').onclick=()=>setMode('file');$('mLink').onclick=()=>setMode('link');
$('addBtn').onclick=()=>{$('cat').innerHTML=CATS.map(c=>'<option value="'+c.id+'">'+c.n+' ('+c.s+')</option>').join('');$('cat').value=cur;$('eErr').textContent='';setMode('file');$('mAdd').classList.add('show')};
$('eGo').onclick=async()=>{
 const title=$('t').value.trim();$('eErr').textContent='';
 if(!title)return $('eErr').textContent='اكتب العنوان';
 const it={cat:$('cat').value,title,desc:$('d').value.trim(),ts:Date.now(),type:mode};
 $('eGo').disabled=true;
 try{
  if(mode==='file'){
   const f=$('f').files[0];if(!f)throw 'اختر ملف';
   if(!assets)throw 'رفع الملفات غير متاح';
   if(f.size>20*1048576)throw 'الحد الأقصى 20MB، استخدم الرابط للملفات الأكبر';
   const r=await assets.upload(f);it.ref=r.id;it.fname=f.name;
  }else{
   const l=$('l').value.trim();if(!/^https?:\/\//i.test(l))throw 'رابط غير صحيح';it.ref=l;
  }
  const id='i'+it.ts;await db.doc('items/'+id).set(it);
  $('mAdd').classList.remove('show');$('t').value=$('d').value=$('l').value='';$('f').value='';
 }catch(e){$('eErr').textContent=typeof e==='string'?e:'فشل النشر'}
 $('eGo').disabled=false;
};
document.querySelectorAll('[data-close]').forEach(b=>b.onclick=()=>b.closest('.modal').classList.remove('show'));

tabs();ui();
(async()=>{
 try{
  const u=await claude.use('user');isAdmin=!!(u&&(u.isOwner()||u.canEdit()));
  db=await claude.use('db');assets=await claude.use('assets');downloads=await claude.use('downloads');
  if(isAdmin&&!me){me='شادي';}
  ui();
  if(db)db.collection('items').onSnapshot(s=>{items=[];s.forEach(d=>items.push({id:d.id,...d.data()}));render()});
 }catch(e){ui()}
})();
</script>
</body>
</html>
