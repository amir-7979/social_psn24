import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../configs/localization/app_localizations.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.background,
          decoration: null,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
              hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).hintColor,
              ),
              hintText: AppLocalizations.of(context)!.translateNested('drawer', 'search'),
              suffixIcon: GestureDetector(
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/appbar/search_icon.svg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: GestureDetector(
                  child: Container(
                    padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'دسته بندی',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: GestureDetector(
                  child: Container(
                    padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'دسته بندی',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: GestureDetector(
                  child: Container(
                    padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'دسته بندی',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: GestureDetector(
                  child: Container(
                    padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'دسته بندی',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: GestureDetector(
                  child: Container(
                    padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'دسته بندی',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: GestureDetector(
                  child: Container(
                    padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'دسته بندی',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
