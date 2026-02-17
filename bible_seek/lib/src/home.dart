import 'package:bible_seek/src/design/app_colors.dart';
import 'package:bible_seek/src/design/radius.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/search.dart';
import 'package:bible_seek/src/signin.dart';
import 'package:bible_seek/src/topic_verses_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.mode_comment_outlined), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
          ],
        ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          FavoritesScreen(),
          MessagesScreen(),
          MoreScreen(),
        ],
      ),
    );
  }
}

final _headerGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    AppColors.brandBlueLight.withValues(alpha: 0.9),
    AppColors.brandBlue,
  ],
);

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          expandedHeight: 220,
          toolbarHeight: 72,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;
              final showFullHeader = height > 175;

              return Stack(
                fit: StackFit.expand,
                children: [
              Container(
                decoration: BoxDecoration(
                  gradient: _headerGradient,
                ),
              ),
                  SafeArea(
                    child: showFullHeader
                        ? SizedBox(
                            height: height,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                        Center(
                                          child: Text(
                                            'BibleSeek',
                                            style: GoogleFonts.kameron(
                                              fontSize: 26,
                                              height: 1.25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _StickySearchBar(),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'What does the Bible',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              Text(
                                                'say about _______ ?',
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _StickySearchBar(),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TrendingCard(),
          ),
        ),
        SliverToBoxAdapter(child: FollowingDevotionsSection()),
      ],
    );
  }
}

/// Sticky search bar shown at the top of the Home tab. Google-app style.
/// Tapping navigates to SearchPage.
class _StickySearchBar extends StatelessWidget {
  const _StickySearchBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage())),
          borderRadius: AppRadius.r35,
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppRadius.r35,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: AppSpacing.space8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 22, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: Text(
                    'Search for topics & keywords',
                    style: AppTextStyles.bodyLarge(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.mic, color: colorScheme.onSurfaceVariant),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: AppSpacing.space4),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SigninPage()),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.secondary,
                    child: Icon(Icons.person, color: colorScheme.onSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
    );
  }
}

/// Model for devotion preview. Replace with API DTO when wired.
class DevotionPreview {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final String timeAgo;
  final String? title;
  final String bodyPreview;
  final String verseRef;
  final int likeCount;
  final int commentCount;

  const DevotionPreview({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.timeAgo,
    this.title,
    required this.bodyPreview,
    required this.verseRef,
    required this.likeCount,
    required this.commentCount,
  });
}

/// Mock devotions for development. Replace with API fetch when ready.
final _mockDevotions = [
  DevotionPreview(
    id: '1',
    authorName: 'Sarah M.',
    authorAvatarUrl: null,
    timeAgo: '2h',
    title: 'Walking in the Spirit',
    bodyPreview:
        'When we walk by the Spirit, we are no longer under the law. The fruit of the Spirit is love, joy, peace...',
    verseRef: 'Romans 8:1–2',
    likeCount: 12,
    commentCount: 3,
  ),
  DevotionPreview(
    id: '2',
    authorName: 'David K.',
    authorAvatarUrl: null,
    timeAgo: '5h',
    title: null,
    bodyPreview:
        'Trust in the Lord with all your heart and lean not on your own understanding. In all your ways submit to him...',
    verseRef: 'Proverbs 3:5–6',
    likeCount: 8,
    commentCount: 1,
  ),
  DevotionPreview(
    id: '3',
    authorName: 'Emma L.',
    authorAvatarUrl: null,
    timeAgo: '1d',
    title: 'Faith Like a Mustard Seed',
    bodyPreview:
        'If you have faith as small as a mustard seed, you can say to this mountain, "Move from here to there" and it will move.',
    verseRef: 'Matthew 17:20',
    likeCount: 24,
    commentCount: 7,
  ),
  DevotionPreview(
    id: '4',
    authorName: 'James T.',
    authorAvatarUrl: null,
    timeAgo: '2d',
    title: null,
    bodyPreview:
        'For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you...',
    verseRef: 'Jeremiah 29:11',
    likeCount: 15,
    commentCount: 0,
  ),
  DevotionPreview(
    id: '5',
    authorName: 'Rachel W.',
    authorAvatarUrl: null,
    timeAgo: '3d',
    title: 'The Good Shepherd',
    bodyPreview:
        'The Lord is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters.',
    verseRef: 'Psalm 23:1–2',
    likeCount: 31,
    commentCount: 5,
  ),
];

class FollowingDevotionsSection extends StatelessWidget {
  const FollowingDevotionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSignedIn = FirebaseAuth.instance.currentUser != null;
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space25,
          AppSpacing.space24,
          AppSpacing.space25,
          AppSpacing.space24,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'From people you follow',
            style: TextStyle(
              fontSize: 18,
              height: 1.25,
              fontFamily: 'BigBottom',
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Devotions and notes from your circle',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          if (isSignedIn)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mockDevotions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DevotionCard(devotion: _mockDevotions[index]),
                );
              },
            )
          else
            _SignInCtaCard(),
        ],
        ),
      ),
    );
  }
}

class _SignInCtaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.brightness == Brightness.dark
              ? colorScheme.outline.withValues(alpha: 0.3)
              : colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Sign in to see devotions from people you follow',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SigninPage()),
              );
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}

class _DevotionCard extends StatelessWidget {
  const _DevotionCard({required this.devotion});

  final DevotionPreview devotion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.brightness == Brightness.dark
              ? colorScheme.outline.withValues(alpha: 0.3)
              : colorScheme.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + author + time
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.secondary,
                backgroundImage: devotion.authorAvatarUrl != null
                    ? NetworkImage(devotion.authorAvatarUrl!)
                    : null,
                child: devotion.authorAvatarUrl == null
                    ? Text(
                        devotion.authorName.isNotEmpty
                            ? devotion.authorName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  devotion.authorName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Text(
                devotion.timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (devotion.title != null && devotion.title!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              devotion.title!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            devotion.bodyPreview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          // Verse reference chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              devotion.verseRef,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Bottom actions
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                '${devotion.likeCount}',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline,
                  size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                '${devotion.commentCount}',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple model for trending topic items. Replace with API data when wired.
class TrendingTopicItem {
  final int id;
  final String name;
  final int searches;

  const TrendingTopicItem({
    required this.id,
    required this.name,
    required this.searches,
  });
}

/// Mock trending topics. Replace with API fetch when ready.
const _mockTrendingTopics = [
  TrendingTopicItem(id: 1, name: 'Grace', searches: 1247),
  TrendingTopicItem(id: 2, name: 'Faith', searches: 982),
  TrendingTopicItem(id: 3, name: 'Forgiveness', searches: 638),
];

class TrendingCard extends StatelessWidget {
  const TrendingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
        AppSpacing.space25,
        AppSpacing.space20,
        AppSpacing.space25,
        AppSpacing.space20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                IconData(0xe392, fontFamily: 'MaterialIcons'),
                color: colorScheme.tertiary,
              ),
              const SizedBox(width: AppSpacing.space5),
              Text(
                'Trending Topics',
                style: AppTextStyles.sectionTitle(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space10),
          for (var i = 0; i < _mockTrendingTopics.length; i++) ...[
            Builder(
              builder: (context) {
                final topic = _mockTrendingTopics[i];
                return TrendingTopicButton(
                  topicName: topic.name,
                  searches: topic.searches,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicVersesScreen(
                          topicId: topic.id.toString(),
                          topicName: topic.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            if (i < _mockTrendingTopics.length - 1)
              const SizedBox(height: AppSpacing.space5),
          ],
          const SizedBox(height: AppSpacing.space5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              backgroundColor: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.r5),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () => print("Object 1"),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'View More',
                    style: AppTextStyles.bodyLarge(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurface),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class TrendingTopicButton extends StatelessWidget {
  const TrendingTopicButton({
    super.key,
    required this.topicName,
    required this.searches,
    required this.onTap,
  });

  final String topicName;
  final int searches;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.r5),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
        minimumSize: const Size(double.infinity, 45),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              topicName,
              style: AppTextStyles.sectionTitle(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$searches searches',
            style: AppTextStyles.bodyText(context),
          ),
        ],
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const SearchInput(
      {required this.textController, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outline;
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 10,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.15)),
      ]),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          //Do something wi
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.primary,
          ),
          filled: true,
          fillColor: colorScheme.surface,
          hintText: hintText,
          hintStyle:
              TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          ),
        ),
      ),
    );
  }
}

class IntroCard extends StatelessWidget {
  const IntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      height: 275,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50.0),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.indigo[800]!.withOpacity(.15),
          //     offset: const Offset(0, 10),
          //     blurRadius: 0,
          //     spreadRadius: 0,
          //   )
          // ],
          gradient: RadialGradient(
        colors: [
          AppColors.brandBlueLight.withValues(alpha: 0.9),
          AppColors.brandBlue,
        ],
        focal: Alignment.topCenter,
        radius: 2,
      )),
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Text("BibleSeek",
              style: GoogleFonts.kameron(
                  fontSize: 32, height: 1.25, color: Colors.white)),
          const SizedBox(height: 24.0),
          Text("What does the Bible",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300)),
          Text("say about _______ ?",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.r35),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
        minimumSize: const Size(double.infinity, 54),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchPage()),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: colorScheme.onSurface),
          const SizedBox(width: AppSpacing.space10),
          Expanded(
            child: Text(
              'Search for topics & keywords',
              style: AppTextStyles.bodyLarge(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.mic, color: colorScheme.onSurface)),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SigninPage()),
            ),
            child: CircleAvatar(
              backgroundColor: colorScheme.secondary,
              child: Icon(Icons.person, color: colorScheme.onSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
