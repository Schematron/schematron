/*
 
Open Source Initiative OSI - The MIT License:Licensing
[OSI Approved License]

The MIT License

Copyright (c) 2008 Rick Jelliffe, Topologi Pty. Ltd, Allette Systems 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


 */

package com.schematron.ant;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.URIResolver;

import net.sf.saxon.TransformerFactoryImpl; // import saxon processor

import java.io.FileOutputStream;
import java.io.PrintStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.Hashtable;
import java.util.Enumeration;

/**
 * A ValidatorFactory instance can be used to create a Validator object.
 * 
 * @author Christophe Lauret
 * @author Willy Ekasalim
 * @author Rick Jelliffe
 * 
 * @version 4 August 2008
 * 
 */
/*
 * 2008-8-14 RJ
 * 		* Fix up resolver so that document("") works inside a jar file, to allow localization. 
 *        document("", /) does not seem to work, however.
 *  
 * 2008-8-06 RJ 
 * 		* Add support for arbitrary entity resolver
 * 
 * 2008-8-04 RJ 
 * 		* Split out preprocessors into different cases * URL resolver to
 * cope with URLs with schemes * Make transformers to handle the pre-processors
 * (not used yet)
 * 
 */
public final class ValidatorFactory {

	/**
	 * The standard schematron preprocessor
	 */
	private static final String INCLUDE_PREPROCESSOR = "/iso_dsdl_include.xsl";
	private static final String ABSTRACT_PREPROCESSOR = "/iso_abstract_expand.xsl";

	private static final String PREPROCESSOR_MESSAGE_OLD = "/schematron-message1-6_XT.xsl";
	private static final String PREPROCESSOR_MESSAGE_XSLT1 = "/iso_schematron_message.xsl";
	private static final String PREPROCESSOR_MESSAGE_XSLT2 = "/iso_schematron_message_xslt2.xsl";

	private static final String PREPROCESSOR_SVRL_XSLT1 = "/iso_svrl_for_xslt1.xsl";
	private static final String PREPROCESSOR_SVRL_XSLT2 = "/iso_svrl_for_xslt2.xsl";
	private static final String PREPROCESSOR_SVRL_OLD = "/iso_svrl_1.6.xsl";

	private static final String PREPROCESSOR_TERMINATE_XSLT1 = "/iso_svrl_for_xslt1.xsl"; // to
																				// do
	private static final String PREPROCESSOR_TERMINATE_XSLT2 = "/iso_svrl_for_xslt2.xsl"; // to
																						// do
	private static final String PREPROCESSOR_TERMINATE_OLD = "/iso_svrl_1.6.xsl"; // to
																					// do

	/**
	 * The transformer factory used to spawn templates.
	 */

	private String thePreprocessor = PREPROCESSOR_SVRL_XSLT1;

	/**
	 * Using the SAXON XSLT processor
	 */

	// This use java built-in XSLT processor
	// private TransformerFactory _factory = TransformerFactory.newInstance();
	private TransformerFactory _factory = TransformerFactoryImpl.newInstance();

	/**
	 * The entity resolver
	 */
	private Class _resolver;

	/**
	 * The error event listener for the ValidatorFactory.
	 */
	private ErrorListener _listener = this._factory.getErrorListener();

	/**
	 * The parameters to be sent to the preprocessor.
	 */
	private Hashtable _parameters = new Hashtable();

	/**
	 * The preprocessor to use.
	 */
	private final Source _abstract_preprocessor;
	private final Source _include_preprocessor;
	private final Source _preprocessor;

	/**
	 * If set to <code>true</code> (default is <code>false</code>), then
	 * preprocessing stylesheet will be outputted to file debug.xslt
	 */
	private boolean debugMode = false;

	// constructors
	// -----------------------------------------------------------------------------------

	/**
	 * Constructs a new ValidatorFactory using the default preprocessor.
	 */
	public ValidatorFactory() {
		this._preprocessor = resolveDefaultPreprocessor();
		this._include_preprocessor = resolvePreprocessor(INCLUDE_PREPROCESSOR);
		this._abstract_preprocessor = resolvePreprocessor(ABSTRACT_PREPROCESSOR);
	}

	/**
	 * Constructs a new ValidatorFactory object using the specified
	 * preprocessor.
	 * 
	 * @param preprocessor
	 *            The preprocessor which generates the validating stylesheet.
	 * 
	 * @throws IllegalArgumentException
	 *             If preprocessor is <code>null</code>.
	 */
	public ValidatorFactory(Source preprocessor)
			throws IllegalArgumentException {
		if (preprocessor == null)
			throw new IllegalArgumentException(
					"The preprocessor must not be null.");
		this._preprocessor = preprocessor;
		this._include_preprocessor = resolvePreprocessor(INCLUDE_PREPROCESSOR);
		this._abstract_preprocessor = resolvePreprocessor(ABSTRACT_PREPROCESSOR);
	}

	/**
	 * Constructs a new ValidatorFactory object using the specified
	 * preprocessor.
	 * Actually, this is not necessary. Future versions may remove this so that
	 * only the SVRL is output.
	 * 
	 * @param preprocessor
	 *            The preprocessor which generates the validating stylesheet.
	 * 
	 * @throws IllegalArgumentException
	 *             If preprocessor is <code>null</code>.
	 */
	public ValidatorFactory(String preprocessor, String formatter)
			throws IllegalArgumentException {
		if (preprocessor == null)
			throw new IllegalArgumentException(
					"The preprocessor must not be null.");

		if (preprocessor.equalsIgnoreCase("xslt2") || preprocessor.equalsIgnoreCase("xpath2"))
			if (formatter.equalsIgnoreCase("message"))
				this.thePreprocessor = PREPROCESSOR_MESSAGE_XSLT2;
			else if (formatter.equalsIgnoreCase("message"))
				this.thePreprocessor = PREPROCESSOR_TERMINATE_XSLT2;
			else
				this.thePreprocessor = PREPROCESSOR_SVRL_XSLT2; 
		else if (preprocessor.equalsIgnoreCase("xslt") || preprocessor.equalsIgnoreCase("xpath")
			|| preprocessor.equalsIgnoreCase("xslt1"))
			if (formatter.equalsIgnoreCase("message"))
				this.thePreprocessor = PREPROCESSOR_MESSAGE_XSLT1;
			else if (formatter.equalsIgnoreCase("message"))
				this.thePreprocessor = PREPROCESSOR_TERMINATE_XSLT1;
			else
				this.thePreprocessor = PREPROCESSOR_SVRL_XSLT1;  
		else if (preprocessor.equalsIgnoreCase("1.5") || preprocessor.equalsIgnoreCase("1.6")
				 || preprocessor.equalsIgnoreCase("old"))
			if (formatter.equalsIgnoreCase("message"))
				this.thePreprocessor = PREPROCESSOR_MESSAGE_OLD;
			else if (formatter.equalsIgnoreCase("message"))
				this.thePreprocessor = PREPROCESSOR_TERMINATE_OLD;
			else
				this.thePreprocessor = PREPROCESSOR_SVRL_OLD;  
		else
		// "auto" is handled as the default
		if (formatter.equalsIgnoreCase("message"))
			this.thePreprocessor = PREPROCESSOR_MESSAGE_XSLT1;
		else if (formatter.equalsIgnoreCase("terminate"))
			this.thePreprocessor = PREPROCESSOR_TERMINATE_XSLT1;
		else
			this.thePreprocessor = PREPROCESSOR_SVRL_XSLT1;

		this._preprocessor = resolvePreprocessor();
		this._include_preprocessor = resolvePreprocessor(INCLUDE_PREPROCESSOR);
		this._abstract_preprocessor = resolvePreprocessor(ABSTRACT_PREPROCESSOR);
	}

	// public methods
	// ----------------------------------------------------------------------------------

	/**
	 * Set the error event listener for the ValidatorFactory, which is used for
	 * the processing of the Schematron schema, not for the Schematron
	 * validation itself.
	 * 
	 * @param listener
	 *            The error listener.
	 * 
	 * @throws IllegalArgumentException
	 *             If listener is <code>null</code>.
	 */
	public void setErrorListener(ErrorListener listener)
			throws IllegalArgumentException {
		if (listener == null)
			throw new IllegalArgumentException(
					"The error listener must not be null.");
		this._listener = listener;
	}

	/**
	 * Get the error event handler for this factory.
	 * 
	 * @return The current error handler, which should never be
	 *         <code>null</code>.
	 */
	public ErrorListener getErrorListener() {
		return this._listener;
	}

	/**
	 * Add a parameter to be sent to the preprocessor.
	 * 
	 * @see javax.xml.transform.Transformer#setParameter(String, Object)
	 * 
	 * @param name
	 *            The name of the parameter.
	 * @param value
	 *            The value object.
	 */
	public void setParameter(String name, Object value) {
		this._parameters.put(name, value);
	}

	/**
	 * Returns the parameters value for hte specified name.
	 * 
	 * @param name
	 *            The name of the parameter.
	 * 
	 * @return The parameter value or <code>null</code> if the parameter was
	 *         not specified.
	 */
	public Object getParameter(String name) {
		return this._parameters.get(name);
	}

	/**
	 * If debug mode is set to true, then preprocessing stylesheet will be
	 * outputted in file debug.xslt This has to be called before
	 * <code>newValidator()</code> to take effect.
	 */

	public void setDebugMode(boolean debugMode) {
		this.debugMode = debugMode;
	}

	/**
	 * Set the class name of the resolver to use, overriding built-in Apache
	 * resolver
	 */
	public void setResolver(Class theResolver) {
		_resolver = theResolver;
	}

	// helper methods for the constructors
	// -------------------------------------------------------------

	/**
	 * Returns the default preprocessor which is included in the classpath or
	 * the jar file resp.
	 * 
	 * @return the default preprocessor which is included in the classpath or
	 *         the jar file resp.
	 * 
	 * @throws TransformerFactoryConfigurationError
	 *             If the pre-processor cannot be found in the classpath.
	 */
	private Source resolveDefaultPreprocessor()
			throws TransformerFactoryConfigurationError {
		URL url = ValidatorFactory.class.getResource(PREPROCESSOR_SVRL_XSLT1);
		if (url == null)
			throw new TransformerFactoryConfigurationError("preprocessor '"
					+ PREPROCESSOR_SVRL_XSLT1
					+ "' cannot be found in the classpath.");
		return new StreamSource(url.toString());
	}

	/**
	 * Returns the preprocessor which is included in the classpath or the jar
	 * file resp.
	 * 
	 * @return the preprocessor which is included in the classpath or the jar
	 *         file resp.
	 * 
	 * @throws TransformerFactoryConfigurationError
	 *             If the pre-processor cannot be found in the classpath.
	 */
	private Source resolvePreprocessor()
			throws TransformerFactoryConfigurationError {
		URL url = ValidatorFactory.class.getResource(thePreprocessor);
		if (url == null)
			throw new TransformerFactoryConfigurationError("preprocessor '"
					+ thePreprocessor + "' cannot be found in the classpath.");
		return new StreamSource(url.toString());
	}

	private Source resolvePreprocessor(String stylesheet)
			throws TransformerFactoryConfigurationError {
		URL url = ValidatorFactory.class.getResource(stylesheet);
		if (url == null)
			throw new TransformerFactoryConfigurationError("preprocessor '"
					+ stylesheet + "' cannot be found in the classpath.");
		return new StreamSource(url.toString());
	}

	/**
	 * Process the specified schema into a Validator object.
	 * 
	 * @param schema
	 *            The Schematron schema to use.
	 * 
	 * @return A Validator instance for the specified schema.
	 * 
	 * @throws TransformerException
	 *             Should an exception be while attempting to instantiate a
	 *             validator.
	 */
	public Validator newValidator(Source schema) throws TransformerException,
			IOException, IllegalAccessException, ClassNotFoundException,
			InstantiationException {

		// System.out.println("currently using factory class: " +
		// this._factory.getClass());

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

		// set some parameters if specified (All transformers get all
		// parameters)
		if (!this._parameters.isEmpty()) {

			Enumeration names = this._parameters.keys();
			while (names.hasMoreElements()) {

				String name = names.nextElement().toString();
				transformer.setParameter(name, this._parameters.get(name));
				abstract_transformer.setParameter(name, this._parameters
						.get(name));
				include_transformer.setParameter(name, this._parameters
						.get(name));
			}
		}

		if (!this._factory.getFeature(StreamResult.FEATURE))
			throw new TransformerConfigurationException(
					"The XSLT processor must support following feature: "
							+ StreamResult.FEATURE);

		// recipient for the transformation
		Interim interim = new Interim(schema.getSystemId());
		
		// make the transformation using the preprocessor

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
		
		
		// check debug mode, if true then print the preprocessing results to
		// debug.xslt
		if (debugMode) {
			interim.saveAs(new File("debug.xslt"));
		}

		// Generate the templates from the preprocessing results

		if (_resolver != null) {

			this._factory.setURIResolver((URIResolver) _resolver.newInstance());
		}
		Templates validator = this._factory.newTemplates(interim.getSource());

		return new Validator(validator);
	}

	/**
	 * An object to store information about the compiled stylesheet before it is
	 * parsed as a template.
	 * 
	 * @author Christophe Lauret
	 * @version 4 January 2007
	 */
	private static class Interim {

		/**
		 * The string writer to use.
		 */
		private StringWriter writer;

		/**
		 * The system identifier of the source Schematron Schema.
		 */
		private final String systemId;

		/**
		 * Creates a new Interim instance.
		 * 
		 * @param systemId
		 *            The system identifier of the source Schematron Schema.
		 */
		public Interim(String systemId) {
			this.systemId = systemId;
		}

		/**
		 * Returns a <code>Result</code> document ready to use by the
		 * transformer.
		 * 
		 * @return a <code>Result</code> ready to use by a
		 *         <code>Transformer</code>.
		 * 
		 * @throws IllegalStateException
		 *             If this method has already been invoked.
		 * 
		 */
		public Result makeEmptyResult() throws IllegalStateException,
				UnsupportedEncodingException {
			if (this.writer != null)
				throw new IllegalStateException(
						"The templates have already been produced.");
			// was this.writer=new StringWriter(); but this doesn't handle
			// encodings properly
			this.writer = new StringWriter();
			// java.io.ByteArrayOutputStream baos = new
			// java.io.ByteArrayOutputStream();
			// this.writer = new OutputStreamWriter(baos);
			return new StreamResult(this.writer);
		}

		/**
		 * Returns a <code>Source</code> ready to use by a
		 * <code>Transformer</code> from the previously produced result.
		 * 
		 * @return a <code>Source</code> ready to use by a
		 *         <code>Transformer</code>.
		 * 
		 * @throws IllegalStateException
		 *             If this method is invoked before results have been
		 *             produced.
		 */
		public Source getSource() throws IllegalStateException {
			if (this.writer == null)
				throw new IllegalStateException(
						"The templates have not been produced.");
			StreamSource source = new StreamSource(new StringReader(this.writer
					.toString()));
			// source.setSystemId( this.systemId);
			source.setPublicId("compiled:" + this.systemId);
			return source;
		}

		/**
		 * Print out the preprocessing stylesheet to given <code>File</code>
		 * 
		 * @throws IOException
		 *             if there are restriction when accessing file debug.xslt.
		 */
		public void saveAs(File file) throws IOException { 
			PrintStream pout = new PrintStream(file, "utf-8");
			// PrintWriter pout = new PrintWriter(fout);
			pout.print(this.writer.toString());
			pout.close(); 
		}

	}

	/**
	 * An Object class that implements URIResolver interface This class
	 * implements "resolve" method that will be called whenever
	 * <code>xsl:include</code> and <code>xsl:import</code> is encountered.
	 * 
	 * This class is designed to allow stylesheets to find other imported /
	 * included stylesheets from within the same jar.
	 * 
	 * (RJ: guess It is used by the compiling stylesheet to allow location
	 * within the same jar? Really not sure why this is needed.)
	 * 
	 * @author Christophe lauret
	 * @author Willy Ekasalim
	 * 
	 * @version 9 February 2007
	 */
	private static class XSLTURIFinder implements URIResolver {

		/**
		 * Returns the <code>Source</code> reference of file from the XSLT
		 * instructions <code>xsl:include</code> or <code>xsl:import</code>
		 * by using the relative path. Don't do this for URLs with a scheme
		 * (have ":")
		 * 
		 * Initially, href would have, for example, 
		 * 	iso_schematron_skeleton_for_xslt1.xsl
		 * and base would have
		 *   jar:file:/C:/Users/ricko/workspace/Schematron-AntTask/test/lib/ant-schematron.jar!/iso_svrl.xsl
		 *   
		 *  However, for referencing other files, it could have
		 *  	href= sch-messages-en.xhtml
		 *  and
		 *  	base = file:/C:/Users/ricko/workspace/Schematron-AntTask/test/schemas/test-message.sch
		 *   
		 * {@inheritDoc}
		 */
		public Source resolve(String href, String base) {
			URL url;
 
			try {
			if  (href == null || href.length() ==0) {
				int bang = base.indexOf("!");
				
				url = ValidatorFactory.class.getResource(base.substring(bang + 1));
			}
				
			else	if (href.contains(":"))
				url = ValidatorFactory.class.getResource(href); 
			else 
				// We don't rebase the resource on the schema path, but in the current archive
				url = ValidatorFactory.class.getResource("/" + href); 
			}
			catch (Exception e) {
				return null; // swallow the exception and make it  URLResolver's business
			}
			return new StreamSource(url.toString());
		}
	}

}
