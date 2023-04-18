* Minimal package to explore issue in generating example images when the example
  doesn't work with ``ragg::agg_png()`` but you've requested the use of ``grDevices::png()`` in ``_pkgdown.yml`` and
  it should work in that example.
* `{pgkdown}` seems to first run examples with ``ragg::agg_png()`` as active graphics device saving plots with ``grDevices::recordPlot()`` and then re-generates the images
  with the requested graphics device with ``grDevices::replayPlot()`` instead of running examples with the requested graphics device.
* ``_pkgdown.yml`` figure code is:

  ```yaml
  figures:
    dev: grDevices::png
    dev.args:
      type: "cairo"
  ```
  and when printing ``pkgdown::fig_settings()`` seems to have been set correctly.

* The example uses the "affine transformation" feature introduced in R 4.2 and I want to skip the example
  unless ``print(isTRUE(dev.capabilities()$transformations))`` (i.e. the active graphics device supports the "affine transformation" feature).  However `{ragg}` does not support this feature while the requested ``grDevices::png(type = "cairo")`` does support this feature.
* Also created a Dockerfile that 1) install development version of `{pgkdown}`, builds pkgdown documentation for this minimal package, and serves the documentation on port 3000:

  ```bash 
  docker build -t trevorld/pkgdown-png .
  docker run --rm -p 3000:3000 trevorld/pkgdown-png
  ```

  Should be able to see minimal example at http://localhost:3000/reference/transformationGrob.html#examples
