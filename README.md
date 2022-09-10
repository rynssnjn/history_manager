# history_manager

An action manager for saving executed changes that allows redoing and undoing of changes occured.

## Usage

Initializing the controller.

```dart
import 'package:history_manager/history_manager.dart';

HistoryController controller = new HistoryController();
```

Creating a simple model by extending to `ExecutedChange` wherein it accepts different types.

```dart
class IncrementChange extends ExecutedChange<int> {
  IncrementChange({
    this.oldValue,
    this.onExecute,
    this.onUndo,
  });
  @override
  final int oldValue;

  @override
  final VoidCallback onExecute;

  @override
  final OnUndoChange<int> onUndo;
}
```

Adding a new executed change.

```dart
var counter = 0;
controller.add(IncrementChange(
  oldValue: counter,
  onExecute: () => counter++,
  onUndo: (c) => counter = c,
));
```

Checking if there is an undoable or a redoable changes.

```dart
controller.canUndo; // checks if there is an undoable change
controller.canRedo; // checks if there is a redoable change.
```

Undoing the change from the last executed change.

```dart
print(counter); // 1
controller.undo();
print(counter); // 0
```

Redoing the last undone change.

```dart
print(counter); // 0
controller.redo();
print(counter); // 1
```

## Example

```dart
class IncrementNumbers extends StatefulWidget {
  const IncrementNumbers({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<IncrementNumbers> createState() => _IncrementNumbersState();
}

class _IncrementNumbersState extends State<IncrementNumbers> {
  int _counter = 0;
  HistoryController controller;

  void _incrementCounter() {
    controller.add(IncrementChange(
      oldValue: _counter,
      onExecute: () => setState(() => _counter++),
      onUndo: (lastValue) => setState(() => _counter = lastValue),
    ));
  }

  @override
  void initState() {
    controller = HistoryController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current count:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            CommonHistoryTools(
              onUndo: controller.undo,
              onRedo: controller.redo,
              canUndo: controller.canUndo,
              canRedo: controller.canRedo,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
