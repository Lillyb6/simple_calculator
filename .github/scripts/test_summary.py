"""Write actual Flutter test results to the GitHub Actions job summary."""
import json
import os
from pathlib import Path

names = {}
results = {}
complete = False
path = Path('test-results.json')
if path.exists():
    for line in path.read_text(encoding='utf-8').splitlines():
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(event, dict):
            continue
        if event.get('type') == 'testStart':
            test = event['test']
            names[test['id']] = test['name']
        elif event.get('type') == 'testDone' and not event.get('hidden', False):
            results[event['testID']] = (
                'skipped' if event.get('skipped') else event['result']
            )
        elif event.get('type') == 'done':
            complete = True

passed = [names.get(i, str(i)) for i, result in results.items() if result == 'success']
failed = [names.get(i, str(i)) for i, result in results.items() if result not in ('success', 'skipped')]
skipped = [names.get(i, str(i)) for i, result in results.items() if result == 'skipped']
lines = ['## Test results', '', f'{len(passed)} passed | {len(failed)} failed | {len(skipped)} skipped', '']
if not complete:
    lines += ['Test run did not finish or results are unavailable.', '']
for title, tests in [('Passed tests', passed), ('Failed tests', failed), ('Skipped tests', skipped)]:
    if tests:
        lines += [f'### {title}', ''] + [f'- {name}' for name in tests] + ['']
summary = '\n'.join(lines)
print(summary)
if os.environ.get('GITHUB_STEP_SUMMARY'):
    with open(os.environ['GITHUB_STEP_SUMMARY'], 'a', encoding='utf-8') as output:
        output.write(summary + '\n')