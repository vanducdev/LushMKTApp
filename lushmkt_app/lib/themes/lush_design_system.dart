import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bảng màu Premium Cyber-Linear (LushDesignSystem)
class LushColors {
  // Dark Blue / Deep Space (Nền vũ trụ xa xỉ)
  static const Color darkBg = Color(0xFF090C15);       // Nền đen sẫm vũ trụ
  static const Color darkSurface = Color(0xFF131722);  // Bề mặt thẻ cấp 1
  static const Color darkCard = Color(0xFF161B22);     // Bề mặt thẻ cấp 2
  
  // Neon Cyber Accents
  static const Color cyan = Color(0xFF00E5FF);         // Neon Cyan công nghệ cao
  static const Color purple = Color(0xFF7000FF);       // Neon Purple huyền bí
  static const Color amethyst = Color(0xFFA033FF);     // Tím hồng rực rỡ
  
  // Clean Whites & Light Grays
  static const Color cleanWhite = Color(0xFFFFFFFF);   // Trắng thuần khiết
  static const Color whiteClean = Color(0xFFF8F9FA);   // Trắng ngọc trai sạch
  static const Color greySubtext = Color(0xFF8E929E);  // Xám chữ phụ
  static const Color borderDark = Color(0xFF222630);   // Đường viền tối mặc định
  
  // Status Colors
  static const Color success = Color(0xFF00E676);      // Xanh lá thành công
  static const Color warning = Color(0xFFFFB300);      // Vàng cảnh báo
  static const Color error = Color(0xFFFF2D55);        // Đỏ báo lỗi
}

/// Hệ thống Typography Premium (SF Pro / Inter)
class LushTypography {
  // Headings sử dụng phong cách Orbitron cơ khí tương lai
  static TextStyle heading1({Color color = Colors.white}) => GoogleFonts.orbitron(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    color: color,
  );

  static TextStyle heading2({Color color = Colors.white}) => GoogleFonts.orbitron(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: color,
  );

  static TextStyle heading3({Color color = Colors.white}) => GoogleFonts.orbitron(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: color,
  );

  // Body text sử dụng Inter hoặc SF Pro cho khả năng hiển thị tối đa
  static TextStyle bodyLarge({Color color = Colors.white}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle bodyMedium({Color color = LushColors.whiteClean}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle bodySmall({Color color = LushColors.greySubtext}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle buttonText({Color color = Colors.black}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: color,
  );

  static TextStyle monospace({Color color = LushColors.cyan}) => GoogleFonts.shareTechMono(
    fontSize: 14,
    color: color,
  );
}

/// 1. BUTTONS: CÁC BIẾN THỂ NÚT BẤM (BUTTON COMPONENT VARIANTS)
class LushGlowingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isSecondary;

  const LushGlowingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      // Secondary Variant: Glassmorphism border với Neon glow mảnh
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LushColors.cyan.withOpacity(0.3)),
          color: Colors.white.withOpacity(0.02),
        ),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(icon, color: LushColors.cyan, size: 18),
                  const SizedBox(width: 8),
                ],
                if (isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: LushColors.cyan, strokeWidth: 2),
                  )
                else
                  Text(
                    text.toUpperCase(),
                    style: LushTypography.buttonText(color: LushColors.cyan),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Primary Variant: Glowing Gradient Button (Stripe & Linear style)
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [LushColors.cyan, LushColors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: LushColors.cyan.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: LushColors.purple.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !isLoading) ...[
                  Icon(icon, color: Colors.black, size: 18),
                  const SizedBox(width: 8),
                ],
                if (isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                  )
                else
                  Text(
                    text.toUpperCase(),
                    style: LushTypography.buttonText(color: Colors.black),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 2. CARDS: THẺ KHO HÀNG GLASSMORPHIC (GLASSMORPHISM COMPONENT VARIANTS)
class LushGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? borderColor;
  final Color? fillColor;
  final VoidCallback? onTap;

  const LushGlassCard({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.borderColor,
    this.fillColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: fillColor ?? LushColors.darkCard.withOpacity(0.75),
            border: Border.all(
              color: borderColor ?? LushColors.cyan.withOpacity(0.12),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: LushColors.cyan.withOpacity(0.08),
        highlightColor: Colors.transparent,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// 3. INPUTS: Ô NHẬP LIỆU PHÁT SÁNG (GLOWING INPUT FIELD COMPONENT VARIANTS)
class LushInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;

  const LushInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<LushInput> createState() => _LushInputState();
}

class _LushInputState extends State<LushInput> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: LushColors.cyan.withOpacity(0.08),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.prefixIcon,
              color: _isFocused ? LushColors.cyan : LushColors.greySubtext,
              size: 20,
            ),
            labelText: widget.label,
            hintText: widget.hint,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: LushColors.greySubtext,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// 4. TOAST: THÔNG BÁO CYBER (PREMIUM DYNAMIC CUSTOM TOASTS)
class LushToast {
  static void show(BuildContext context, String message, {bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: LushGlassCard(
              fillColor: LushColors.darkSurface.withOpacity(0.95),
              borderColor: isError ? LushColors.error.withOpacity(0.5) : LushColors.cyan.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Icon(
                      isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                      color: isError ? LushColors.error : LushColors.success,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: LushTypography.bodyMedium(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    
    // Tự động đóng toast sau 3.5 giây
    Future.delayed(const Duration(milliseconds: 3500), () {
      overlayEntry.remove();
    });
  }
}

/// 5. MODAL: NGĂN KÉO BOTTOM SHEET (PREMIUM GLASS DRAWER MODALS)
class LushModal {
  static void showBottomSheet({
    required BuildContext context,
    required Widget title,
    required Widget content,
    List<Widget>? actions,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LushGlassCard(
          fillColor: LushColors.darkBg.withOpacity(0.95),
          borderColor: LushColors.purple.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh kéo phía trên đỉnh đầu modal
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                title,
                const SizedBox(height: 16),
                content,
                if (actions != null && actions.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions.map((w) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: w,
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
