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

class _CustomTitleBarState extends State<CustomTitleBar> {
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
            _buildWindowButtons(),
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

  Widget _buildWindowButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowButton(
          color: Colors.redAccent,
          icon: Icons.close,
          onTap: () => windowManager.close(),
        ),
        const SizedBox(width: 8),
        _WindowButton(
          color: Colors.orangeAccent,
          icon: Icons.remove,
          onTap: () => windowManager.minimize(),
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
        ),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _WindowButton({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
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
            color: _isHovered ? widget.color : widget.color.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: _isHovered
              ? Icon(widget.icon, size: 10, color: Colors.black87)
              : null,
        ),
      ),
    );
  }
}
