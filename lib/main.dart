import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const adminUser = 'shade015'; // الحساب الأدمن (الوحيد الذي يضيف ويحذف)

const cats = <List<String>>[
  ['mods_be', 'مودات بيدروك'],
  ['mods_java', 'مودات جافا'],
  ['rp_be', 'ريسورس بيدروك'],
  ['rp_java', 'ريسورس جافا'],
  ['worlds', 'العوالم'],
  ['hacks', 'الهاكات'],
];

void main() => runApp(const MyApp());

class Item {
  String id, cat, title, desc, type, ref, fname;
  Item(this.id, this.cat, this.title, this.desc, this.type, this.ref, this.fname);
  Map<String, dynamic> toJson() => {
        'id': id, 'cat': cat, 'title': title, 'desc': desc,
        'type': type, 'ref': ref, 'fname': fname
      };
  factory Item.fromJson(Map<String, dynamic> j) => Item(j['id'], j['cat'],
      j['title'], j['desc'] ?? '', j['type'], j['ref'], j['fname'] ?? '');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ماين كرافت هب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F9B2F)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3F9B2F), brightness: Brightness.dark),
      ),
      builder: (c, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences sp;
  bool ready = false;
  List<Item> items = [];
  Map<String, dynamic> accounts = {};
  String? me;

  bool get isAdmin => me == adminUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    sp = await SharedPreferences.getInstance();
    items = (jsonDecode(sp.getString('items') ?? '[]') as List)
        .map((e) => Item.fromJson(e))
        .toList();
    accounts = jsonDecode(sp.getString('accounts') ?? '{}');
    me = sp.getString('me');
    setState(() => ready = true);
  }

  Future<void> _saveItems() =>
      sp.setString('items', jsonEncode(items.map((e) => e.toJson()).toList()));

  String _hash(String salt, String p) =>
      sha256.convert(utf8.encode(salt + p)).toString();

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  // ---------- تسجيل الدخول / إنشاء حساب ----------
  void _authDialog() {
    final u = TextEditingController(), p = TextEditingController();
    bool signup = false;
    String err = '';
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, set) {
        return AlertDialog(
          title: Text(signup ? 'إنشاء حساب' : 'تسجيل الدخول'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: u,
                decoration: const InputDecoration(labelText: 'اسم المستخدم')),
            TextField(
                controller: p,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور')),
            if (err.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(err, style: const TextStyle(color: Colors.red))),
            TextButton(
                onPressed: () => set(() {
                      signup = !signup;
                      err = '';
                    }),
                child: Text(signup
                    ? 'عندي حساب؟ سجل دخول'
                    : 'ما عندي حساب؟ أنشئ حساب')),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () async {
                final name = u.text.trim().toLowerCase(), pass = p.text;
                if (!RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(name)) {
                  return set(() => err = 'الاسم: 3-20 حرف إنجليزي/أرقام/_');
                }
                if (pass.length < 6) {
                  return set(() => err = 'كلمة المرور 6 أحرف على الأقل');
                }
                final acc = accounts[name];
                if (signup) {
                  if (acc != null) return set(() => err = 'الاسم مستخدم');
                  final salt = DateTime.now().microsecondsSinceEpoch.toString();
                  accounts[name] = {'salt': salt, 'hash': _hash(salt, pass)};
                  await sp.setString('accounts', jsonEncode(accounts));
                } else {
                  if (acc == null || acc['hash'] != _hash(acc['salt'], pass)) {
                    return set(() => err = 'بيانات الدخول غير صحيحة');
                  }
                }
                await sp.setString('me', name);
                setState(() => me = name);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(signup ? 'إنشاء' : 'دخول'),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _logout() async {
    await sp.remove('me');
    setState(() => me = null);
  }

  // ---------- إضافة محتوى (للأدمن فقط) ----------
  void _addDialog(String defCat) {
    final t = TextEditingController(),
        d = TextEditingController(),
        l = TextEditingController();
    String cat = defCat, mode = 'file', err = '';
    PlatformFile? picked;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, set) {
        return AlertDialog(
          title: const Text('إضافة جديد'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<String>(
                value: cat,
                items: cats
                    .map((c) =>
                        DropdownMenuItem(value: c[0], child: Text(c[1])))
                    .toList(),
                onChanged: (v) => set(() => cat = v!),
              ),
              TextField(
                  controller: t,
                  decoration: const InputDecoration(labelText: 'العنوان')),
              TextField(
                  controller: d,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'الوصف')),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'file', label: Text('ملف'), icon: Icon(Icons.folder)),
                  ButtonSegment(value: 'link', label: Text('رابط'), icon: Icon(Icons.link)),
                ],
                selected: {mode},
                onSelectionChanged: (s) => set(() => mode = s.first),
              ),
              const SizedBox(height: 8),
              if (mode == 'file')
                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: Text(picked?.name ?? 'اختر ملف'),
                  onPressed: () async {
                    final r = await FilePicker.platform.pickFiles();
                    if (r != null) set(() => picked = r.files.first);
                  },
                )
              else
                TextField(
                    controller: l,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(hintText: 'https://...')),
              if (err.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(err, style: const TextStyle(color: Colors.red))),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () async {
                if (t.text.trim().isEmpty) return set(() => err = 'اكتب العنوان');
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                String ref, fname = '';
                if (mode == 'file') {
                  if (picked?.path == null) return set(() => err = 'اختر ملف');
                  final dir = await getApplicationDocumentsDirectory();
                  final up = Directory('${dir.path}/uploads');
                  await up.create(recursive: true);
                  fname = picked!.name;
                  final dest = '${up.path}/${id}_$fname';
                  await File(picked!.path!).copy(dest);
                  ref = dest;
                } else {
                  ref = l.text.trim();
                  if (!RegExp(r'^https?://', caseSensitive: false).hasMatch(ref)) {
                    return set(() => err = 'رابط غير صحيح');
                  }
                }
                items.add(Item(id, cat, t.text.trim(), d.text.trim(), mode, ref, fname));
                await _saveItems();
                setState(() {});
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('نشر'),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _open(Item i) async {
    if (i.type == 'link') {
      final ok = await launchUrl(Uri.parse(i.ref), mode: LaunchMode.externalApplication);
      if (!ok) _snack('تعذر فتح الرابط');
    } else {
      final r = await OpenFilex.open(i.ref);
      if (r.type != ResultType.done) _snack('تعذر فتح الملف');
    }
  }

  Future<void> _delete(Item i) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('حذف "${i.title}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('لا')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok != true) return;
    if (i.type == 'file') {
      try { await File(i.ref).delete(); } catch (_) {}
    }
    items.removeWhere((e) => e.id == i.id);
    await _saveItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: cats.length,
      child: Builder(builder: (context) {
        final tc = DefaultTabController.of(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            title: const Text('⛏️ ماين كرافت هب',
                style: TextStyle(fontWeight: FontWeight.w900)),
            actions: [
              if (me != null)
                Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text('👤 $me${isAdmin ? ' (مشرف)' : ''}',
                            style: const TextStyle(fontSize: 12)))),
              IconButton(
                tooltip: me == null ? 'تسجيل الدخول' : 'تسجيل الخروج',
                icon: Icon(me == null ? Icons.login : Icons.logout),
                onPressed: me == null ? _authDialog : _logout,
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              labelColor: cs.onPrimary,
              unselectedLabelColor: cs.onPrimary.withOpacity(.7),
              indicatorColor: cs.onPrimary,
              tabs: cats.map((c) => Tab(text: c[1])).toList(),
            ),
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  onPressed: () => _addDialog(cats[tc.index][0]),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة'),
                )
              : null,
          body: Column(children: [
            Expanded(
              child: TabBarView(
                children: cats.map((c) {
                  final list = items.where((e) => e.cat == c[0]).toList().reversed.toList();
                  if (list.isEmpty) {
                    return const Center(child: Text('لا يوجد محتوى بعد في هذا القسم'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, k) {
                      final i = list[k];
                      return Card(
                        child: ListTile(
                          title: Text(i.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${i.desc}\n${i.type == 'file' ? 'ملف' : 'رابط'}'),
                          isThreeLine: true,
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.download), onPressed: () => _open(i)),
                            if (isAdmin)
                              IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _delete(i)),
                          ]),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('© جميع الحقوق محفوظة لـ شادي\nتيك توك: @shade015',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
            ),
          ]),
        );
      }),
    );
  }
}