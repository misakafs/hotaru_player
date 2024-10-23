import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final List<Option> options;
  final dynamic selected;
  final void Function(Option option)? onSelected;

  const SettingTile({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 30.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 20);
            },
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return GestureDetector(
                onTap: () {
                  if (onSelected != null) {
                    onSelected!(option);
                  }
                },
                child: Text(
                  option.t,
                  style: TextStyle(
                    color: selected == option.v ? Theme.of(context).primaryColor : Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class Option {
  final String t;
  final dynamic v;

  const Option(this.t, this.v);
}
