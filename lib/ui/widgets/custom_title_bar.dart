import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomTitleBar extends StatefulWidget {
  final String title;
  final IconData? icon;
  final List<Widget>? actions;

  const CustomTitleBar({super.key, required this.title, this.icon, this.actions});

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> with WindowListener {
  bool _isFocused = true;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _checkFocus();
  }

  void _checkFocus() async {
    bool focused = await windowManager.isFocused();
    if (mounted) {
      setState(() {
        _isFocused = focused;
      });
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    setState(() {
      _isFocused = true;
    });
  }

  @override
  void onWindowBlur() {
    setState(() {
      _isFocused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DragToMoveArea(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEBEBEB),
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white10 : Colors.black12,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // Custom macOS style buttons
            _buildWindowButtons(isDark),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 16, color: isDark ? Colors.white70 : Colors.black87),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.actions != null) ...[
              ...widget.actions!,
              const SizedBox(width: 16),
            ] else ...[
              const SizedBox(width: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWindowButtons(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowButton(
          color: Colors.redAccent,
          icon: Icons.close,
          onTap: () => windowManager.close(),
          isFocused: _isFocused,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _WindowButton(
          color: Colors.orangeAccent,
          icon: Icons.remove,
          onTap: () => windowManager.minimize(),
          isFocused: _isFocused,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _WindowButton(
          color: Colors.greenAccent,
          icon: Icons.add,
          onTap: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
          isFocused: _isFocused,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final bool isFocused;
  final bool isDark;

  const _WindowButton({
    required this.color,
    required this.icon,
    required this.onTap,
    required this.isFocused,
    required this.isDark,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final unfocusedColor = widget.isDark ? Colors.white24 : Colors.black26;
    final baseColor = widget.isFocused ? widget.color : unfocusedColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: widget.isFocused 
                ? (_isHovered ? baseColor : baseColor.withValues(alpha: 1.0)) 
                : baseColor,
            shape: BoxShape.circle,
          ),
          child: (_isHovered && widget.isFocused)
              ? Icon(widget.icon, size: 10, color: Colors.black87)
              : null,
        ),
      ),
    );
  }
}
