class SizeHelper {
  static double h10 = 0.0;
  static double h15 = 0.0;
  static double h20 = 0.0;
  static double h25 = 0.0;
  static double h30 = 0.0;
  static double h35 = 0.0;
  static double h40 = 0.0;
  static double h45 = 0.0;
  static double h50 = 0.0;
  static double h200 = 0.0;

  static double w10 = 0.0;
  static double w15 = 0.0;
  static double w20 = 0.0;
  static double w25 = 0.0;
  static double w30 = 0.0;
  static double w35 = 0.0;
  static double w40 = 0.0;
  static double w45 = 0.0;
  static double w50 = 0.0;
  static double w98 = 0.0;

  static void init(double screenWidth, double screenHeight) {
    // Heights
    h10 = screenHeight * (10 / screenHeight);
    h15 = screenHeight * (15 / screenHeight);
    h20 = screenHeight * (20 / screenHeight);
    h25 = screenHeight * (25 / screenHeight);
    h30 = screenHeight * (30 / screenHeight);
    h35 = screenHeight * (35 / screenHeight);
    h40 = screenHeight * (40 / screenHeight);
    h45 = screenHeight * (45 / screenHeight);
    h50 = screenHeight * (50 / screenHeight);
    h200 = screenHeight * (200 / screenHeight);

    // Widths
    w10 = screenWidth * (10 / screenWidth);
    w15 = screenWidth * (15 / screenWidth);
    w20 = screenWidth * (20 / screenWidth);
    w25 = screenWidth * (25 / screenWidth);
    w30 = screenWidth * (30 / screenWidth);
    w35 = screenWidth * (35 / screenWidth);
    w40 = screenWidth * (40 / screenWidth);
    w45 = screenWidth * (45 / screenWidth);
    w50 = screenWidth * (50 / screenWidth);
    w98 = screenWidth * (98 / screenWidth);
  }
}
