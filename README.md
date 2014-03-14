hejSCB
======

A GUI for accessing the database of Statistics Sweden

### Installation
Install the application to your hard drive by cloning this repository.

### Running the app
The app can be run from within R:
```
require(shiny)
runApp("path/to/hejSCB") # If your current working directory is the 'hejSCB' root, simply run 'runApp()' instead
```

Note that _hejSCB_ depends on the dev versions of some R packages, including `shiny` and `rCharts`.
