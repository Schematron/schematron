# RunningSchematronWithJava #

There are a variety of options. If using any of these, remember to update the XSLTs to the most recent versions from this site, where appropriate.

  * Alex Brown's [Probotron4J](http://www.probatron.org/probatron4j.html) library on Google Code
  * The Schematron for Ant Task on the site in Google Code provides an example, given below.
  * Topologi has an older example using [JAXP](http://www.topologi.com/public/Schematron.zip) that needs to be updated with more recent XSLT scripts.
  * Oliver Becker has an early [Schematron Java API](http://www2.informatik.hu-berlin.de/~obecker/SchematronAPI/) which may be of interest.


Note that the Java API documentation actually [mentions Schematron](http://download.oracle.com/docs/cd/E17476_01/javase/1.5.0/docs/api/javax/xml/validation/package-summary.html), for use with their validation factory. However, I am not sure if anyone implements it directly.


---

Here is a example fragment from the [Schematron Task for Ant](http://code.google.com/p/schematron/source/browse/trunk/ant-schematron/code/src/com/schematron/ant/ValidatorFactory.java) code. Actually, this probably makes things look far too complicated: I will track down some more direct code.

```

 // *Create Transformer Instances*
                Transformer include_transformer = this._factory
                                .newTransformer(this._include_preprocessor);
                Transformer abstract_transformer = this._factory
                                .newTransformer(this._abstract_preprocessor);

                // set uri resolver for transformer to locate xsl:include and xsl:import
                this._factory.setURIResolver(new XSLTURIFinder());
                Transformer transformer = this._factory
                                .newTransformer(this._preprocessor);

                include_transformer.setErrorListener(this._listener);
                abstract_transformer.setErrorListener(this._listener);
                transformer.setErrorListener(this._listener);

// *Transform in a pipeline*
                // 1) Preprocess inclusions
                DOMResult r1 = new DOMResult();
                include_transformer.transform(schema, r1);

                // 2) Preoprocess abstracts
                DOMResult r2 = new DOMResult();
                DOMSource s2 = new DOMSource( r1.getNode());
                abstract_transformer.transform(s2, r2);
                r1 = null;  // housekeeping for large schemas


                // 3) generate output
 
                DOMSource s3 = new DOMSource( r2.getNode());
                transformer.transform(s3, interim.makeEmptyResult());
                r2 = null;  // housekeeping for large schemas
               
               
                // Generate the templates from the preprocessing results

                if (_resolver != null) {

                        this._factory.setURIResolver((URIResolver) _resolver.newInstance());
                }
                Templates validator = this._factory.newTemplates(interim.getSource());

// Return the validator
                return new Validator(validator);

```