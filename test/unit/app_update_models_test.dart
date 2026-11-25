import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/features/updates/domain/app_update_models.dart';

void main() {
  group('SemanticVersion', () {
    test('parses standard, v-prefixed, and build-numbered versions', () {
      expect(
        SemanticVersion.tryParse('v1.2.3'),
        const SemanticVersion(major: 1, minor: 2, patch: 3),
      );
      expect(
        SemanticVersion.tryParse('1.0.1+2'),
        const SemanticVersion(major: 1, minor: 0, patch: 1, buildNumber: 2),
      );
      expect(
        SemanticVersion.tryParse('V2.4.0-rc1+10'),
        const SemanticVersion(major: 2, minor: 4, patch: 0, buildNumber: 10),
      );
      expect(SemanticVersion.tryParse('not-a-version'), isNull);
    });

    test('compares major, minor, patch, and build numbers accurately', () {
      final v100 = SemanticVersion.tryParse('1.0.0+1')!;
      final v100b2 = SemanticVersion.tryParse('1.0.0+2')!;
      final v101 = SemanticVersion.tryParse('v1.0.1')!;
      final v110 = SemanticVersion.tryParse('v1.1.0')!;
      final v200 = SemanticVersion.tryParse('v2.0.0')!;

      expect(v100b2.isNewerThan(v100), isTrue);
      expect(v101.isNewerThan(v100b2), isTrue);
      expect(v110.isNewerThan(v101), isTrue);
      expect(v200.isNewerThan(v110), isTrue);
      expect(v100.isNewerThan(v100), isFalse);
      expect(v100.isNewerThan(v101), isFalse);
    });
  });
}
