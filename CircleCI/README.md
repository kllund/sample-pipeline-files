# CircleCI

## Tips, Tricks, and Cautions

Here is a few tips and tricks for CircleCI along with some things to be aware of.

### Error 137

In CircleCI you might hit an error reported by CircleCI named "Error 137".
This is because if the CI job uses over its allocated memory of the machine, CircleCI will kill the process automatically.

To prevent this, restrict the CodeQL process RAM usage by addding the `--ram` argument:

```bash
codeql database analyze \
    --ram 7000
```

CodeQL comes with some overhead on top of the value set (plus over processes could be running) so add padding to this value is recommended.
