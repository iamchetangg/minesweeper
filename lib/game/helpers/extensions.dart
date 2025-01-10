import 'dart:math';

extension randoms on List {
  get random => this[Random().nextInt(length - 1)];
}
