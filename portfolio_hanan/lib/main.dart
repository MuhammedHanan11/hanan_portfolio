import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'dart:ui';

Future<void> _launchURL(String url) async {
  debugPrint('Launching: $url');
  final Uri uri = Uri.parse(url);
  try {
    // For WhatsApp and other external links, externalApplication is best.
    // For mailto/tel, it's also highly recommended.
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('First launch attempt failed: $e');
    try {
      // Fallback for some browsers or platforms that block externalApplication
      await launchUrl(uri);
    } catch (e2) {
      debugPrint('All launch attempts failed: $e2');
    }
  }
}

void main() {
  runApp(const HananPortfolio());
}

class HananPortfolio extends StatelessWidget {
  const HananPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammed Hanan KK | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      home: const PortfolioHome(),
    );
  }
}

const kBg = Color(0xFF080808);
const kCard = Color(0xFF121212);
const kCardHover = Color(0xFF1A1A1A);
const kAccent = Color(0xFFFF4D00); 
const kAccentLight = Color(0xFFFF6A2E);
const kAccentGlow = Color(0xFFFF4D00);
const kBorder = Color(0xFF222222);
const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = Color(0xFFAAAAAA);
const kTextMuted = Color(0xFF666666);

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _workKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late AnimationController _heroController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _heroFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOut));
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
        );
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _ScrollReveal(
                  controller: _scrollController,
                  child: _HeroSection(
                    key: _homeKey,
                    fadeAnim: _heroFade,
                    slideAnim: _heroSlide,
                    onContact: () => _scrollTo(_contactKey),
                  ),
                ),
                _ScrollReveal(
                  controller: _scrollController,
                  child: _ServicesSection(key: _servicesKey),
                ),
                _ScrollReveal(
                  controller: _scrollController,
                  child: _AboutSection(
                    key: _aboutKey,
                    onContact: () => _scrollTo(_contactKey),
                  ),
                ),
                _ScrollReveal(
                  controller: _scrollController,
                  child: _StatsSection(),
                ),
                _ScrollReveal(
                  controller: _scrollController,
                  child: _WorkSection(key: _workKey),
                ),
                _ScrollReveal(
                  controller: _scrollController,
                  child: _ContactSection(key: _contactKey),
                ),
                const _Footer(),
              ],
            ),
          ),
          _NavBar(
            onHome: () => _scrollTo(_homeKey),
            onServices: () => _scrollTo(_servicesKey),
            onAbout: () => _scrollTo(_aboutKey),
            onWork: () => _scrollTo(_workKey),
            onContact: () => _scrollTo(_contactKey),
          ),
          const _CursorDot(),
        ],
      ),
    );
  }
}

// ─── NAV BAR ──────────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final VoidCallback onHome, onServices, onAbout, onWork, onContact;
  const _NavBar({
    required this.onHome,
    required this.onServices,
    required this.onAbout,
    required this.onWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 80,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1200 ? 100 : 40,
            ),
            decoration: BoxDecoration(
              color: kBg.withOpacity(0.7),
              border: const Border(
                bottom: BorderSide(color: kBorder, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Modern Logo
                Text(
                  'HANAN',
                  style: GoogleFonts.syne(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 2,
                    color: kTextPrimary,
                  ),
                ),
                Text(
                  '.',
                  style: GoogleFonts.syne(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: kAccent,
                  ),
                ),
                const Spacer(),
                if (MediaQuery.of(context).size.width > 900) ...[
                  _NavLink(label: 'Home', onTap: onHome),
                  _NavLink(label: 'Services', onTap: onServices),
                  _NavLink(label: 'About', onTap: onAbout),
                  const SizedBox(width: 20),
                ],
                _ModernBtn(
                  label: 'LET\'S TALK',
                  onTap: onContact,
                  isPrimary: true,
                  width: 140,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _hovered ? kAccent : kTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── HERO SECTION ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final VoidCallback onContact;
  const _HeroSection({
    super.key,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1200;

    return Container(
      width: double.infinity,
      color: kBg,
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 120 : 40,
        isDesktop ? 80 : 60,
        isDesktop ? 120 : 40,
        80,
      ),
      child: FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Content
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: kAccent.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: kAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'CREATIVE GRAPHIC DESIGNER',
                                style: GoogleFonts.inter(
                                  color: kAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Elevating Brands\nThrough Visual\nStorytelling.',
                          style: GoogleFonts.syne(
                            fontSize: w > 1200 ? 64 : (w > 600 ? 42 : 32),
                            fontWeight: FontWeight.w800,
                            color: kTextPrimary,
                            height: 1.1,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Muhammed Hanan KK is a 21-year-old creative designer\nspecialized in graphic designing and motion graphics.',
                          style: GoogleFonts.inter(
                            fontSize: w > 1200 ? 16 : 14,
                            color: kTextSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _ModernBtn(
                              label: 'LET\'S TALK',
                              onTap: onContact,
                              isPrimary: true,
                              width: 180,
                              height: 54,
                            ),
                            _ModernBtn(
                              label: 'CHAT ON WHATSAPP',
                              onTap: () =>
                                  _launchURL('https://wa.me/919995785711'),
                              isPrimary: false,
                              width: 180,
                              height: 54,
                            ),
                          ],
                        ),
                        if (!isDesktop) ...[
                          const SizedBox(height: 60),
                          Center(child: _HeroImage(isDesktop: false)),
                        ],
                      ],
                    ),
                  ),
                  // Right Photo/Graphic
                  if (isDesktop)
                    Expanded(flex: 4, child: _HeroImage(isDesktop: true)),
                ],
              ),
              // const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final bool isDesktop;
  const _HeroImage({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final frameWidth = isDesktop ? 350.0 : 280.0;
    final frameHeight = isDesktop ? 480.0 : 380.0;

    return Container(
      alignment: isDesktop ? Alignment.centerRight : Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Abstract Glow
          Container(
            width: isDesktop ? 400 : 320,
            height: isDesktop ? 400 : 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [kAccent.withOpacity(0.15), Colors.transparent],
              ),
            ),
          ),
          // Profile Frame
          Container(
            width: frameWidth,
            height: frameHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/hannan.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => Container(
                        color: kCard,
                        child: Icon(
                          Icons.person,
                          size: isDesktop ? 120 : 80,
                          color: kTextMuted,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          color: kBg.withOpacity(0.5),
                          child: Center(
                            child: Text(
                              'HANAN KK',
                              style: GoogleFonts.syne(
                                color: kTextPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: isDesktop ? 18 : 14,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SERVICES SECTION ─────────────────────────────────────────────────────────
class _ServicesSection extends StatelessWidget {
  const _ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1200;

    final services = [
      {
        'icon': Icons.brush_outlined,
        'title': 'Graphic Designing',
        'desc':
            'Creating high-impact visual designs using Photoshop, Illustrator, and InDesign.',
      },
      {
        'icon': Icons.movie_filter_outlined,
        'title': 'Motion Graphics',
        'desc':
            'Bringing concepts to life with professional video editing and After Effects animation.',
      },
      {
        'icon': Icons.people_outline,
        'title': 'Handling People',
        'desc':
            'Excellent communication skills and project management with a client-focused approach.',
      },
      {
        'icon': Icons.dashboard_customize_outlined,
        'title': 'Multimedia Designs',
        'desc':
            'Integrated design solutions across multiple platforms and various digital media.',
      },
    ];

    return Container(
      width: double.infinity,
      color: kBg,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 40,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModernSectionLabel(label: 'EXPERTISE'),
          const SizedBox(height: 24),
          Text(
            'Specialized in crafting\nexceptional designs.',
            style: GoogleFonts.syne(
              fontSize: isDesktop ? 48 : 32,
              fontWeight: FontWeight.w800,
              color: kTextPrimary,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isDesktop
                  ? (constraints.maxWidth - 30) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 30,
                runSpacing: 30,
                children: services
                    .map(
                      (s) => SizedBox(
                        width: cardWidth,
                        child: _ServiceCard(
                          icon: s['icon'] as IconData,
                          title: s['title'] as String,
                          desc: s['desc'] as String,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title, desc;
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.desc,
  });
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: _hovered ? kCardHover : kCard,
          border: Border.all(
            color: _hovered ? kAccent.withOpacity(0.5) : kBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 40,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _hovered ? kAccent : kAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                widget.icon,
                color: _hovered ? Colors.white : kAccent,
                size: 32,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.title,
              style: GoogleFonts.syne(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.desc,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: kTextSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ABOUT SECTION ────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  final VoidCallback onContact;
  const _AboutSection({super.key, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1200;

    return Container(
      width: double.infinity,
      color: const Color(0xFF060606),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 40,
        vertical: 120,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ModernSectionLabel(label: 'BIOGRAPHY'),
                    const SizedBox(height: 24),
                    Text(
                      'Designing with\nImpact and\nPrecision.',
                      style: GoogleFonts.syne(
                        fontSize: isDesktop ? 48 : 32,
                        fontWeight: FontWeight.w800,
                        color: kTextPrimary,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Hello, I am Muhammed Hanan kk. I am a 21-year-old Graphic Designer and Motion Artist from Kerala. I have a qualification in PlusTwo and Multimedia. My passion lies in creating visual solutions that bridge the gap between aesthetics and functionality.',
                      style: GoogleFonts.inter(
                        fontSize: isDesktop ? 16 : 14,
                        color: kTextSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'With core skills in Graphic Designing and Motion Graphics, I also excel in handling people and project collaboration. Based in Unnikulam, I am always ready for new creative challenges.',
                      style: GoogleFonts.inter(
                        fontSize: isDesktop ? 16 : 14,
                        color: kTextSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _ModernBtn(
                      label: 'GET IN TOUCH',
                      onTap: onContact,
                      isPrimary: true,
                      width: 180,
                      height: 54,
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 100),
              if (isDesktop)
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SKILLS & TOOLS',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: kTextMuted,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const _SkillsRow(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillsRow extends StatelessWidget {
  const _SkillsRow();
  @override
  Widget build(BuildContext context) {
    final skills = [
      {'label': 'Photoshop', 'value': 0.9, 'color': Color(0xFF31A8FF)},
      {'label': 'Illustrator', 'value': 0.85, 'color': Color(0xFFFF9A00)},
      {'label': 'InDesign', 'value': 0.8, 'color': Color(0xFFFF3366)},
      {'label': 'After Effects', 'value': 0.75, 'color': Color(0xFF9999FF)},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: skills
            .map(
              (s) => _SkillCircle(
                label: s['label'] as String,
                value: s['value'] as double,
                color: s['color'] as Color,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SkillCircle extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _SkillCircle({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 32),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6,
                  backgroundColor: kBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: kTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


class _AboutInfo extends StatelessWidget {
  final String label, value;
  const _AboutInfo({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.barlowCondensed(
              fontSize: 11,
              color: kAccent,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: kTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 0.5, color: kBorder),
        ],
      ),
    );
  }
}

// ─── STATS SECTION ────────────────────────────────────────────────────────────
class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final stats = [
      {'value': '21', 'label': 'Years Old'},
      {'value': 'PlusTwo', 'label': 'Qualification'},
      {'value': 'Multimedia', 'label': 'Specialized'},
      {'value': '100%', 'label': 'Dedication'},
    ];
    return Container(
      width: double.infinity,
      color: const Color(0xFF040404),
      padding: EdgeInsets.symmetric(
        horizontal: w > 1200 ? 120 : 40,
        vertical: 100,
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: w > 1200 ? 100 : 40,
          runSpacing: 40,
          children: stats
              .map(
                (s) => Column(
                  children: [
                    Text(
                      s['value']!,
                      style: GoogleFonts.syne(
                        fontSize: w > 600 ? 52 : 32,
                        fontWeight: FontWeight.w800,
                        color: kTextPrimary,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s['label']!.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kTextMuted,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ─── WORK / PORTFOLIO SECTION ─────────────────────────────────────────────────
class _WorkSection extends StatelessWidget {
  const _WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Hide work section as requested
  }
}

class _PortfolioCard extends StatefulWidget {
  final Map<String, dynamic> project;
  const _PortfolioCard({required this.project});
  @override
  State<_PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<_PortfolioCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final color = widget.project['color'] as Color;
    final tag = widget.project['tag'] as String;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _hovered ? kAccent.withOpacity(0.5) : kBorder,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedScale(
                        scale: _hovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 600),
                        child: CustomPaint(
                          painter: _PortfolioBgPainter(color: color),
                        ),
                      ),
                    ),
                    if (tag.isNotEmpty)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Text(
                              tag,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.project['category'],
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: kAccent,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.project['year'],
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: kTextMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.project['title'],
                        style: GoogleFonts.syne(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioBgPainter extends CustomPainter {
  final Color color;
  _PortfolioBgPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(color.value);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF111111),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * (0.3 + rng.nextDouble() * 0.3),
        0,
        size.width * 0.5,
        size.height * 0.6,
      ),
      Paint()..color = color.withOpacity(0.12),
    );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.75),
      size.width * 0.25,
      Paint()..color = color.withOpacity(0.07),
    );
    final lp = Paint()
      ..color = color.withOpacity(0.06)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 24)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), lp);
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width, size.height * 0.4),
      Paint()
        ..color = color.withOpacity(0.2)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ─── CONTACT SECTION ──────────────────────────────────────────────────────────
class _ContactSection extends StatelessWidget {
  const _ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      color: const Color(0xFF0A0A0A),
      padding: EdgeInsets.symmetric(
        horizontal: w > 1200 ? 120 : 40,
        vertical: 90,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ModernSectionLabel(label: 'GET IN TOUCH'),
          const SizedBox(height: 24),
          Text(
            'Let\'s work together.',
            style: GoogleFonts.syne(
              fontSize: w > 1200 ? 64 : 42,
              fontWeight: FontWeight.w800,
              color: kTextPrimary,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Have a project in mind? Let\'s create something extraordinary.',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: kTextSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 30,
              runSpacing: 30,
              children: [
                SizedBox(
                  width: 320,
                  child: _ContactInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: 'mhd4hanan@gmail.com',
                    onTap: () => _launchURL('mailto:mhd4hanan@gmail.com'),
                  ),
                ),
                SizedBox(
                  width: 320,
                  child: _ContactInfoCard(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    value: '+91 9995785711',
                    onTap: () => _launchURL('tel:+919995785711'),
                  ),
                ),
                SizedBox(
                  width: 320,
                  child: _ContactInfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: 'Estate Mukku, Unnikulam (po),\nKerala – 673574',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final VoidCallback? onTap;
  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: kCard,
            border: Border.all(color: kBorder, width: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(icon, color: kAccent, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 11,
                      color: kTextMuted,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: kTextPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─── FOOTER ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1200;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 40,
        vertical: 40,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF080808),
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: w > 700
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_FooterLogo(), _FooterCopyright(), _FooterLocation()],
            )
          : Column(
              children: [
                _FooterLogo(),
                const SizedBox(height: 16),
                _FooterCopyright(),
                const SizedBox(height: 8),
                _FooterLocation(),
              ],
            ),
    );
  }
}

class _FooterLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: kAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'H',
              style: GoogleFonts.barlowCondensed(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'HANAN KK',
          style: GoogleFonts.syne(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 1,
            color: kTextPrimary,
          ),
        ),
      ],
    );
  }
}

class _FooterCopyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2024 Muhammed Hanan KK.',
      style: GoogleFonts.inter(fontSize: 12, color: kTextMuted),
    );
  }
}

class _FooterLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Handcrafted in Kerala 🇮🇳',
      style: GoogleFonts.inter(
        fontSize: 12,
        color: kAccent,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────
class _ModernSectionLabel extends StatelessWidget {
  final String label;
  const _ModernSectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 32, height: 1, color: kAccent),
        const SizedBox(width: 12),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: kAccent,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ModernBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final double? width;
  final double? height;
  const _ModernBtn({
    required this.label,
    required this.onTap,
    this.isPrimary = true,
    this.width,
    this.height,
  });
  @override
  State<_ModernBtn> createState() => _ModernBtnState();
}

class _ModernBtnState extends State<_ModernBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          padding: widget.width != null || widget.height != null
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_hovered ? kAccentLight : kAccent)
                : Colors.transparent,
            gradient: widget.isPrimary && _hovered
                ? LinearGradient(
                    colors: [kAccentLight, kAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: Border.all(
              color: widget.isPrimary ? Colors.transparent : kBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: widget.isPrimary && _hovered
                ? [
                    BoxShadow(
                      color: kAccent.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1,
                color: widget.isPrimary
                    ? Colors.white
                    : (_hovered ? kAccent : kTextPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w > 1200;
    return Wrap(
      spacing: isDesktop ? 80 : 40,
      runSpacing: 30,
      alignment: WrapAlignment.start,
      children: const [
        _HeroStatItem(value: '21', label: 'Years Old'),
        _HeroStatItem(value: 'Multimedia', label: 'Media Artist'),
        _HeroStatItem(value: '100%', label: 'Passion'),
      ],
    );
  }
}

class _HeroStatItem extends StatelessWidget {
  final String value, label;
  const _HeroStatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.syne(
            fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
            fontWeight: FontWeight.w800,
            color: kTextPrimary,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: kTextMuted,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _CursorDot extends StatefulWidget {
  const _CursorDot();
  @override
  State<_CursorDot> createState() => _CursorDotState();
}

class _CursorDotState extends State<_CursorDot> {
  Offset _pos = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: MouseRegion(
        opaque: false,
        onHover: (e) => setState(() => _pos = e.position),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 80),
              left: _pos.dx - 8,
              top: _pos.dy - 8,
              child: IgnorePointer(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: kAccent.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SCROLL REVEAL ─────────────────────────────────────────────────────────────
class _ScrollReveal extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  const _ScrollReveal({required this.child, required this.controller});

  @override
  State<_ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<_ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    widget.controller.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted || _isVisible) return;
    final object = context.findRenderObject() as RenderBox?;
    if (object == null) return;

    final viewportHeight = MediaQuery.of(context).size.height;
    final position = object.localToGlobal(Offset.zero).dy;

    if (position < viewportHeight * 0.9) {
      if (!_isVisible) {
        setState(() => _isVisible = true);
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

