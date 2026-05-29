import "dart:ui";

class Palette {
  //* Full Tailwind Colors Palette
  static Map<int, Color> blueGray = {
    50: HexColor('#FFF8FA'),
    100: HexColor('#F1F5F9'),
    200: HexColor('#E2E8F0'),
    300: HexColor('#CBD5E1'),
    400: HexColor('#94A3B8'),
    500: HexColor('#64748B'),
    600: HexColor('#475569'),
    700: HexColor('#334155'),
    800: HexColor('#1E293B'),
    900: HexColor('#0F172A'),
  };
  static Map<int, Color> coolGray = {
    50: HexColor('#F9FAFB'),
    100: HexColor('#F3F4F6'),
    200: HexColor('#E5E7EB'),
    300: HexColor('#D1D5DB'),
    400: HexColor('#9CA3AF'),
    500: HexColor('#6B7280'),
    600: HexColor('#4B5563'),
    700: HexColor('#374151'),
    800: HexColor('#1F2937'),
    900: HexColor('#111827'),
  };
  static Map<int, Color> gray = {
    50: HexColor('#FAFAFA'),
    100: HexColor('#F4F4F5'),
    200: HexColor('#E4E4E7'),
    300: HexColor('#D4D4D8'),
    400: HexColor('#A1A1AA'),
    500: HexColor('#71717A'),
    600: HexColor('#52525B'),
    700: HexColor('#3F3F46'),
    800: HexColor('#27272A'),
    900: HexColor('#18181B'),
  };
  static Map<int, Color> trueGray = {
    50: HexColor('#FAFAFA'),
    100: HexColor('#F5F5F5'),
    200: HexColor('#E5E5E5'),
    300: HexColor('#D4D4D4'),
    400: HexColor('#A3A3A3'),
    500: HexColor('#737373'),
    600: HexColor('#525252'),
    700: HexColor('#404040'),
    800: HexColor('#262626'),
    900: HexColor('#171717'),
  };
  static Map<int, Color> warmGray = {
    50: HexColor('#FAFAF9'),
    100: HexColor('#F5F5F4'),
    200: HexColor('#E7E5E4'),
    300: HexColor('#D6D3D1'),
    400: HexColor('#A8A29E'),
    500: HexColor('#78716C'),
    600: HexColor('#57534E'),
    700: HexColor('#44403C'),
    800: HexColor('#292524'),
    900: HexColor('#1C1917'),
  };
  static Map<int, Color> red = {
    50: HexColor('#FEF2F2'),
    100: HexColor('#FEE2E2'),
    200: HexColor('#FECACA'),
    300: HexColor('#FCA5A5'),
    400: HexColor('#F87171'),
    500: HexColor('#EF4444'),
    600: HexColor('#DC2626'),
    700: HexColor('#B91C1C'),
    800: HexColor('#991B1B'),
    900: HexColor('#7F1D1D'),
  };
  static Map<int, Color> orange = {
    50: HexColor('#FFF7ED'),
    100: HexColor('#FFEDD5'),
    200: HexColor('#FED7AA'),
    300: HexColor('#FDBA74'),
    400: HexColor('#FB923C'),
    500: HexColor('#F97316'),
    600: HexColor('#EA580C'),
    700: HexColor('#C2410C'),
    800: HexColor('#9A3412'),
    900: HexColor('#7C2D12'),
  };
  static Map<int, Color> amber = {
    50: HexColor('#FFFBEB'),
    100: HexColor('#FEF3C7'),
    200: HexColor('#FDE68A'),
    300: HexColor('#FCD34D'),
    400: HexColor('#FBBF24'),
    500: HexColor('#F59E0B'),
    600: HexColor('#D97706'),
    700: HexColor('#B45309'),
    800: HexColor('#92400E'),
    900: HexColor('#78350F'),
  };
  static Map<int, Color> yellow = {
    50: HexColor('#FEFCE8'),
    100: HexColor('#FEF9C3'),
    200: HexColor('#FEF08A'),
    300: HexColor('#FDE047'),
    400: HexColor('#FACC15'),
    500: HexColor('#EAB308'),
    600: HexColor('#CA8A04'),
    700: HexColor('#A16207'),
    800: HexColor('#854D0E'),
    900: HexColor('#713F12'),
  };
  static Map<int, Color> lime = {
    50: HexColor('#F7FEE7'),
    100: HexColor('#ECFCCB'),
    200: HexColor('#D9F99D'),
    300: HexColor('#BEF264'),
    400: HexColor('#A3E635'),
    500: HexColor('#84CC16'),
    600: HexColor('#65A30D'),
    700: HexColor('#4D7C0F'),
    800: HexColor('#3F6212'),
    900: HexColor('#365314'),
  };
  static Map<int, Color> green = {
    50: HexColor('#F0FDF4'),
    100: HexColor('#DCFCE7'),
    200: HexColor('#BBF7D0'),
    300: HexColor('#86EFAC'),
    400: HexColor('#4ADE80'),
    500: HexColor('#22C55E'),
    600: HexColor('#16A34A'),
    700: HexColor('#15803D'),
    800: HexColor('#166534'),
    900: HexColor('#14532D'),
  };
  static Map<int, Color> emerald = {
    50: HexColor('#ECFDF5'),
    100: HexColor('#D1FAE5'),
    200: HexColor('#A7F3D0'),
    300: HexColor('#6EE7B7'),
    400: HexColor('#34D399'),
    500: HexColor('#10B981'),
    600: HexColor('#059669'),
    700: HexColor('#047857'),
    800: HexColor('#065F46'),
    900: HexColor('#064E3B'),
  };
  static Map<int, Color> teal = {
    50: HexColor('#F0FDFA'),
    100: HexColor('#CCFBF1'),
    200: HexColor('#99F6E4'),
    300: HexColor('#5EEAD4'),
    400: HexColor('#2DD4BF'),
    500: HexColor('#14B8A6'),
    600: HexColor('#0D9488'),
    700: HexColor('#0F766E'),
    800: HexColor('#115E59'),
    900: HexColor('#134E4A'),
  };
  static Map<int, Color> cyan = {
    50: HexColor('#ECFEFF'),
    100: HexColor('#CFFAFE'),
    200: HexColor('#A5F3FC'),
    300: HexColor('#67E8F9'),
    400: HexColor('#22D3EE'),
    500: HexColor('#06B6D4'),
    600: HexColor('#0891B2'),
    700: HexColor('#0E7490'),
    800: HexColor('#155E75'),
    900: HexColor('#164E63'),
  };
  static Map<int, Color> sky = {
    50: HexColor('#F0F9FF'),
    100: HexColor('#E0F2FE'),
    200: HexColor('#BAE6FD'),
    300: HexColor('#7DD3FC'),
    400: HexColor('#38BDF8'),
    500: HexColor('#0EA5E9'),
    600: HexColor('#0284C7'),
    700: HexColor('#0369A1'),
    800: HexColor('#075985'),
    900: HexColor('#0C4A6E'),
  };
  static Map<int, Color> blue = {
    50: HexColor('#EFF6FF'),
    100: HexColor('#DBEAFE'),
    200: HexColor('#BFDBFE'),
    300: HexColor('#93C5FD'),
    400: HexColor('#60A5FA'),
    500: HexColor('#3B82F6'),
    600: HexColor('#2563EB'),
    700: HexColor('#1D4ED8'),
    800: HexColor('#1E40AF'),
    900: HexColor('#1E3A8A'),
  };
  static Map<int, Color> indigo = {
    50: HexColor('#EEF2FF'),
    100: HexColor('#E0E7FF'),
    200: HexColor('#C7D2FE'),
    300: HexColor('#A5B4FC'),
    400: HexColor('#818CF8'),
    500: HexColor('#6366F1'),
    600: HexColor('#4F46E5'),
    700: HexColor('#4338CA'),
    800: HexColor('#3730A3'),
    900: HexColor('#312E81'),
  };
  static Map<int, Color> violet = {
    50: HexColor('#F5F3FF'),
    100: HexColor('#EDE9FE'),
    200: HexColor('#DDD6FE'),
    300: HexColor('#C4B5FD'),
    400: HexColor('#A78BFA'),
    500: HexColor('#8B5CF6'),
    600: HexColor('#7C3AED'),
    700: HexColor('#6D28D9'),
    800: HexColor('#5B21B6'),
    900: HexColor('#4C1D95'),
  };
  static Map<int, Color> purple = {
    50: HexColor('#FAF5FF'),
    100: HexColor('#F3E8FF'),
    200: HexColor('#E9D5FF'),
    300: HexColor('#D8B4FE'),
    400: HexColor('#C084FC'),
    500: HexColor('#A855F7'),
    600: HexColor('#9333EA'),
    700: HexColor('#7E22CE'),
    800: HexColor('#6B21A8'),
    900: HexColor('#581C87'),
  };
  static Map<int, Color> fuchsia = {
    50: HexColor('#FDF4FF'),
    100: HexColor('#FAE8FF'),
    200: HexColor('#F5D0FE'),
    300: HexColor('#F0ABFC'),
    400: HexColor('#E879F9'),
    500: HexColor('#D946EF'),
    600: HexColor('#C026D3'),
    700: HexColor('#A21CAF'),
    800: HexColor('#86198F'),
    900: HexColor('#701A75'),
  };
  static Map<int, Color> pink = {
    50: HexColor('#FDF2F8'),
    100: HexColor('#FCE7F3'),
    200: HexColor('#FBCFE8'),
    300: HexColor('#F9A8D4'),
    400: HexColor('#F472B6'),
    500: HexColor('#EC4899'),
    600: HexColor('#DB2777'),
    700: HexColor('#BE185D'),
    800: HexColor('#9D174D'),
    900: HexColor('#831843'),
  };
  static Map<int, Color> rose = {
    50: HexColor('#FFF1F2'),
    100: HexColor('#FFE4E6'),
    200: HexColor('#FECDD3'),
    300: HexColor('#FDA4AF'),
    400: HexColor('#FB7185'),
    500: HexColor('#F43F5E'),
    600: HexColor('#E11D48'),
    700: HexColor('#BE123C'),
    800: HexColor('#9F1239'),
    900: HexColor('#881337'),
  };
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
