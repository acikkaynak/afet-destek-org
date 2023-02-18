import 'package:afet_destek/gen/assets.gen.dart';
import 'package:afet_destek/gen/translations/locale_keys.g.dart';
import 'package:afet_destek/shared/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage._();

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (ctx) => const AboutPage._(),
      ),
    );
  }

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? version;
  String? buildNumber;

  @override
  void initState() {
    super.initState();
    setPackageInfo();
  }

  Future<void> setPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(Assets.logoSvg),
          )
        ],
        leadingWidth: 52,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              LocaleKeys.about_page_title.getStr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              shrinkWrap: true,
              children: [
                _AboutCard(
                  title: LocaleKeys.who_we_are_title.getStr(),
                  initiallyExpanded: true,
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: LocaleKeys.who_we_are_text.getStr(),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _AboutCard(
                  title: LocaleKeys.what_we_do_title.getStr(),
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: LocaleKeys.what_we_do_text.getStr(),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _AboutCard(
                  title: LocaleKeys.what_is_our_goal_title.getStr(),
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: LocaleKeys.what_is_our_goal_text.getStr(),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _AboutCard(
                  title: LocaleKeys.different_from_others_title.getStr(),
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: LocaleKeys.different_from_others_text.getStr(),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _AboutCard(
                  title: LocaleKeys.contact_info_title.getStr(),
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: LocaleKeys.contact_info_phone_title.getStr(),
                      value: '+90 (555) 555 5555',
                    ),
                    _AboutDetail(
                      text: LocaleKeys.contact_info_email_title.getStr(),
                      value: 'test@test.com',
                    ),
                    _AboutDetail(
                      text: LocaleKeys.contact_info_text.getStr(),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _AboutCard(
                  title: LocaleKeys.social_media_info_title.getStr(),
                  children: const [
                    Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: 'Facebook:',
                      value: '-',
                    ),
                    _AboutDetail(
                      text: 'Instagram:',
                      value: '-',
                    ),
                    _AboutDetail(
                      text: 'Twitter:',
                      value: '-',
                    ),
                    _AboutDetail(
                      text: 'Linkedin:',
                      value: '-',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _AboutCard(
                  title: LocaleKeys.app_version_title.getStr(),
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    _AboutDetail(
                      text: LocaleKeys.app_version_text.getStr(),
                      value: version ?? '-',
                    ),
                    _AboutDetail(
                      text: LocaleKeys.app_build_number_text.getStr(),
                      value: buildNumber ?? '-',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutDetail extends StatelessWidget {
  const _AboutDetail({required this.text, this.value});
  final String text;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerLeft,
      child: value == null
          ? Text(
              text,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            )
          : Row(
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(width: 5),
                if (value != null)
                  Text(
                    value!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
              ],
            ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        collapsedTextColor: Theme.of(context).textTheme.bodyMedium?.color,
        initiallyExpanded: initiallyExpanded,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        tilePadding: const EdgeInsets.only(left: 16, right: 16),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: children,
      ),
    );
  }
}
