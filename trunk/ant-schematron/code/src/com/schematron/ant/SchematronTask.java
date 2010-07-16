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

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.SourceLocator;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.AntClassLoader;
import org.apache.tools.ant.types.Path;
import org.apache.tools.ant.types.Reference; 

/**
 * An Ant task that allows user to validate a fileset of XML files with a Schematron schema.
 * 
 * Functional specifications
 *
 * The schematron ant task should process the file(s) specified by the user either directly or using
 * <ul>
 *   <li>the fileset Ant concept for a better integration with ant.</li>
 *   <li>The ant task must specify the ISO Schematron schema file to use.</li>
 *   <li>Optionally, the user can specify a phase.</li>
 * </ul>
 * 
 * All arguments should be properly parsed using Ant methods so that Ant arguments and concept can be specified.
 * 
 * The configuration of the XSLT transformer should be inherited from the JAXP properties.
 * 
 * @author Christophe lauret
 * @author Willy Ekasalim
 * @author Rick Jelliffe
 * 
 * @version  2008-08-14 RJ
 * 		* add support for langCode parameter 
 * 
 * version 4 August 2008 RJ
 *    	* Expose many more parameters for use in the Ant task attributes
 *    	* Add support for arbitrary resolver
 *      * Add new parameters to allow the filename to be chunked and available to the metastylesheets
 */
/**
 * @TODO
 *   The character encoding issues have not been worked through.
 *   Terminate needs to be tested. We want to be able to terminate on first failed assert but keep on
 *   with reports.
 *   Do we really want schematron_message? 
 *   Is Fileset working?
 */
public final class SchematronTask extends Task {

  /**
   * Specify the query language binding of schematron to use
   * (Schematron 1.n is counted as a language!)
   * "xslt1" "xslt2" "old" "auto"
   */	
   private String queryLanguageBinding = "auto";
   
   /**
    * Specify the format  (metastylesheet)
    * "svrl" (default), "message" or "terminate"
    */
   private String format ="svrl";
	
  /**
   * Specifies a Schematron phase to use.  
   */
  private String phase;

  /**
   * The Schematron schema file.  
   */
  private File schema;
  
  /**
   * The path to the directory where the output file should be stored.
   */
  private String outputDir;
  
  /**
   * The name of the file where the results will be stored.
   */
  private String outputFilename = "result.xml";

  /**
   * A file to be Schematron validated.  
   */
  private File file;

  /**
   * Set of files to be Schematron validated.  
   */
  private final ArrayList<FileSet> filesets = new ArrayList();

  /**
   * The Schematron validator.
   */
  private Validator validator;

  /**
   * If set to <code>true</code> (default), throws a buildException if the parser yields an error.
   */
  private boolean failOnError = true;
  
  /**
   * If set to <code>true</code> (default is <code>false</code>), then preprocessing stylesheet will be outputted to file debug.xslt
   */
  private boolean debugMode = false;
  
  /** 
   * command-line parameters of the skeleton
   *     
    phase           NMTOKEN | "#ALL" (default) Select the phase for validation
    allow-foreign   "true" | "false" (default)   Pass non-Schematron elements to the generated stylesheet
    sch.exslt.imports semi-colon delimited string of filenames for some EXSLT implementations  
    message-newline "true" (default) | "false"   Generate an extra newline at the end of messages 
    debug	    "true" | "false" (default)  Debug mode lets compilation continue despite problems
    attributes "true" | "false"  (Autodetecting) Use only when the schema has no attributes as the context nodes
    only-child-elements "true" | "false" (Autodetecting) Use only when the schema has no comments
    or PI  as the context nodes
    
 Experimental: USE AT YOUR OWN RISK   
    visit-text "true" "false"   Also visist text nodes for context. WARNING: NON_STARDARD.
    select-contents '' | 'key' | '//'   Select different implementation strategies
 
 Conventions: Meta-stylesheets that override this may use the following parameters
    generate-paths=true|false   generate the @location attribute with XPaths
    diagnose= yes | no    Add the diagnostics to the assertion test in reports
    terminate= yes | no   Terminate on the first failed assertion or successful report
   */
    private String allow_foreign;
    private String sch_exlst_imports;
    private String message_newline; 
    private String attributes;
    private String only_child_elements;
    private String visit_text;
    private String select_contents;
    private String generate_paths;
    private String diagnose;
    private String terminate;
    

    private String langCode;
    
    /*
     * Parameters from include and abstract pre-processors
     * Schema-id is in iso_abstract_expand and is used for selecting a particular schema
     * from when there are multiple schemas embedded in, say, an NVRL file
     */
    private String schema_id;
    
    /*
     * Other Ant Parameters  
     */
    private String resolver;

    /** name for XSL parameter containing the filename */
    private String archiveNameParameter = null;

    /** name for XSL parameter containing the file directory */
    private String archiveDirParameter = null;
    
    /** name for XSL parameter containing the filename */
    private String fileNameParameter = null;

    /** name for XSL parameter containing the file directory */
    private String fileDirParameter = null;
    
    /** Classpath to use when trying to load the XSL processor */
    private Path classpath = null;
    
 
    /** Encoding for output */
    private String encoding = null;
    
    /**
     * AntClassLoader for the nested &lt;classpath&gt; - if set.
     * 
     */
    private AntClassLoader loader = null;

// public methods ---------------------------------------------------------------------------------

  /**
   * Specify how parser error are to be handled.
   * 
   * Optional, default is <code>true</code>.
   * 
   * If set to <code>true</code> (default), throws a buildException if the parser yields an error.
   * 
   * @param fail if set to <code>false</code> do not fail on error
   */
  public void setFailOnError(boolean fail) {
    this.failOnError = fail;
  }
  
  /**
   * Specify which binding to use "xslt1", "xslt2" or "old"
   * @param binding
   */
  public void setQueryLanguageBinding( String binding) {
	  this.queryLanguageBinding = binding;
  }
  
  /**
   * Specify which output format to use "svrl", "message" or "terminate". 
   * SVRL is an XML format. "message" is a simple text format as is 
   * "terminate" which halts after the first failed assertion.
   */
  public void setFormat(String theFormat) {
	  this.format = theFormat;
  }
  /**
   * Specify whether preprocessor stylesheet are to be print into file for debugging.
   * 
   * Optional, default is <code>false</code>.
   * 
   * If set to <code>true</code> output preprocessing stylesheet into file debug.xslt
   * 
   * @param debug if set to <code>false</code> do not output preprocessing stylesheet to file.
   */
  public void setDebugMode(boolean debug) {
    this.debugMode = debug;
  }

  /**
   * Specifies the phase Schematron should use.
   * 
   * If this parameter is set the schematron processor will match this parameter value with
   * the 'id' attribute of a phase element.
   * 
   * @param phase The ID of the phase to use.
   */
  public void setPhase(String phase) {
    this.phase = phase;
  }

  /**
   * Specify the file to be checked; optional.
   * 
   * @param file The file to check
   */
  public void setSchema(File file) {
    this.schema = file;
  }

  /**
   * Specify the file to be checked; optional.
   * 
   * @param file The file to check
   */
  public void setFile(File file) {
    this.file = file;
  }
  
  /**
   * Specify the path to the directory where the output file should be stored.
   * 
   * Optional, default is the current directory.
   * 
   * @param outputDir the path to the directory where the output file should be stored.
   */
  public void setOutputDir(String outputDir) {
    this.outputDir = outputDir;
  }
  
  /**
   * Specify the name of the file where the results will be stored.
   * 
   * Optional, default is <code>result.xml</code>.
   * 
   * @param outputFilename the name of the file where the results will be stored.
   */
  public void setOutputFilename(String outputFilename) {
    this.outputFilename = outputFilename;
  }

  /**
   * Specifies a semicolon separated list of catalog files
   */
  public void setCatalog( String data) {
	  System.setProperty("xml.catalog.files", data);
  }
  
  /**
   * Specifies a set of file to be checked
   * 
   * @param set The set of files to check
   */
  public void addFileset(FileSet set) {
    this.filesets.add(set);
  }

  // allow-foreign   "true" | "false" (default)   Pass non-Schematron elements to the generated stylesheet
  public void setAllow_foreign( String value) {
  	this.allow_foreign = value;
}
  //sch.exslt.imports semi-colon delimited string of filenames for some EXSLT implementations  
  public void setSch_exlst_imports ( String value) {
	  	this.sch_exlst_imports  = value;
	}
  //message-newline "true" (default) | "false"   Generate an extra newline at the end of messages
  public void setMessage_newline ( String value) {
	  	this.message_newline  = value;
	} 
  //attributes "true" | "false"  (Autodetecting) Use only when the schema has no attributes as the context nodes
  public void setAttributes ( String value) {
	  	this.attributes  = value;
	}
 
  //only-child-elements "true" | "false" (Autodetecting) Use only when the schema has no comments or PI  as the context nodes
  public void setOnly_child_elements ( String value) {
	  	this.only_child_elements  = value;
	}
  
  //visit-text "true" "false"   Also visist text nodes for context. WARNING: NON_STARDARD.
  public void setVisit_text ( String value) {
	  	this.visit_text  = value;
	}
  //select-contents '' | 'key' | '//'   Select different implementation strategies
  public void setSelect_contents ( String value) {
	  	this.select_contents  = value;
	}
 //generate-paths=true|false   generate the @location attribute with XPaths
  public void setGenerate_paths ( String value) {
	  	this.generate_paths  = value;
	}
  //diagnose= yes | no    Add the diagnostics to the assertion test in reports
  public void setDiagnose ( String value) {
	  	this.diagnose  = value;
	}
  //terminate= yes | no   Terminate on the first failed assertion or successful report
  public void setTerminate ( String value) {
	  	this.terminate  = value;
	}
  //schema-id = NMTOKEN   the id of the Schematron schema to use (when there are multiples)
  public void setSchema_id( String value) {
	  this.schema_id = value;
  }
  

  //langCode = NMTOKEN   the language of compiler messages
  public void setLangCode( String value) {
	  this.langCode = value;
  }
  
  // Entity resolver for validation
  public void setResolver (String value) {
	  this.resolver = value;
  }

  /**
   * Pass the filename of the current processed file as a xsl parameter
   * to the transformation. This value sets the name of that xsl parameter.
   *
   * @param value    fileNameParameter name of the xsl parameter retrieving the
   *                          current file name
   */
  public void setFileNameParameter(String value) {
      this.fileNameParameter = value;
  }

  /**
   * Pass the directory name of the current processed file as a xsl parameter
   * to the transformation. This value sets the name of that xsl parameter.
   *
   * @param value fileDirParameter name of the xsl parameter retrieving the
   *                         current file directory
   */
  public void setFileDirParameter(String value) {
      this.fileDirParameter = value;
  }
  /**
   * Pass the filename of the current processed file as a xsl parameter
   * to the transformation. This value sets the name of that xsl parameter.
   *
   * @param value archiveNameParameter name of the xsl parameter retrieving the
   *                          current file name
   */
  public void setArchiveNameParameter(String value) {
      this.archiveNameParameter = value;
  }

  /**
   * Pass the directory name of the current processed file as a xsl parameter
   * to the transformation. This value sets the name of that xsl parameter.
   *
   * @param value  archiveDirParameter name of the xsl parameter retrieving the
   *                         current file directory
   */
  public void setarchiveDirParameter(String value) {
      this.archiveDirParameter = value;
  }
  
  /**
   * Set the encoding to be used.
   * 
   * This is hardcoded into the output element of the final XSLT, and passed to the
   * metastylesheet using the output-encoding parameter. 
   */
  public void setOutputEncoding( String value) {
	  encoding=value;
  }
  
  /* ====================================================================================*/
  
  /**
   * Executes this task.
   * 
   * This method will:
   * 
   * 1. Produce the Templates instances
   *   a. Locate the schema file in file system
   *   b. Locate the skeleton file in classpath
   *   c. Transform the source schema with the skeleton
   *   d. Parse the output of the transformation as Template instances
   *   e. Store for reuse
   *   f. Optionally, save as file in file system for debugging
   * 
   * 2. Process the XML files
   *   a. Locate each source XML file to validate
   *   b. Transform each file with the generated templates
   *   c. Capture the output and messages in the Ant/standard output
   *
   * Note: 'Locate' means that the value and fileset from Ant may need 
   * to be parsed/processed so that each file can be found an checked prior to processing.
   * 
   * @throws BuildException Should an error occur
   */
  public void execute() throws BuildException {
    // the number of file processed
    int fileProcessed = 0;

    // verify that we have at least one file to validate
    if (this.file == null && (this.filesets.size() == 0)) {
      throw new BuildException("Specify at least one source - a file or a fileset.");
    }

    // verify that we have at least one schema specified
    if (this.schema == null) {
      throw new BuildException("Specify at least one schema.");
    } else if (!(this.schema.exists() && this.schema.canRead() && this.schema.isFile())) {
      throw new BuildException("Schema "+this.schema+" cannot be read");
    }

    // initialises the validator
    initValidator();

    // initialises Schematron Report to store the validation result
    SchematronReport report = new SchematronReport();

    // when only one file is specified
    if (this.file != null) {
      if (this.file.exists() && this.file.canRead() && this.file.isFile()) {
        SchematronResult result = doValidate(this.file);
        report.add(result);
        fileProcessed++;
      } else {
        String message = "File " + this.file + " cannot be read";
        if (this.failOnError) {
          throw new BuildException(message);
        } else {
          log(message, Project.MSG_ERR);
        }
      }
    }   

    // when filesets are specified
    for (int i = 0; i < this.filesets.size(); i++) {
      FileSet fs = (FileSet)this.filesets.get(i);
      DirectoryScanner ds = fs.getDirectoryScanner(getProject());
      String[] files = ds.getIncludedFiles();
      for (int j = 0; j < files.length; j++) {
        File srcFile = new File(fs.getDir(getProject()), files[j]);
        SchematronResult result = doValidate(srcFile);
        
        //Check if failOnError is set to true, then validation stop if a file is invalid
        if (this.failOnError) {
          if (!result.isValid()) {
            result.printFailedMessage(this);
            return;
          }
        }
        report.add(result);
        fileProcessed++;
        Thread.yield();  // Slows down this, but maybe better citizen with other threads
      }
    }
    try {
      File resultFile = new File(this.outputDir, this.outputFilename);
      report.saveAs(resultFile);
    } catch (IOException ex) {
      throw new BuildException("Unable to write to file: " + ex.getMessage());
    } finally {
        if (loader != null) {
            loader.resetThreadContextLoader();
            loader.cleanup();
            loader = null;
        }
    }
    try {
      report.printLog(this);

    } catch (Exception ex) {

      throw new BuildException(ex.getMessage());
    } 
    log(fileProcessed + " file(s) have been successfully validated.");
  }

// Private helpers --------------------------------------------------------------------------------

  /**
   * Initialise the validator.
   * 
   * Loads the parser class, and set features if necessary
   * 
   * @throws BuildException Should an error occur whilst initialising the Schematron validator. 
   */
  private void initValidator() throws BuildException {
    try {
      System.setProperty("javax.xml.transform.TransformerFactory",
          "net.sf.saxon.TransformerFactoryImpl");
      ValidatorFactory factory;

       factory = new ValidatorFactory(queryLanguageBinding, format );
       
       if (resolver != null && resolver.length() > 0)
    	   factory.setResolver(loadClass(resolver));
       
      // set debugging mode
      factory.setDebugMode(debugMode);
      factory.setErrorListener(new Listener());
      
      // set the phase if specified
      if (this.phase != null) {
        factory.setParameter("phase", this.phase);
      }

      // Other command line options available 
      if (this.allow_foreign !=null) {
    	  factory.setParameter("allow-foreign", this.allow_foreign );
      } 
        
      if (this.sch_exlst_imports !=null) {
    	  factory.setParameter("sch.exslt.imports", this.sch_exlst_imports );
      } 
      if (this.message_newline !=null) {
    	  factory.setParameter("message-newline", this.message_newline  );
      }      
      
       if (this.attributes !=null) {
    	  factory.setParameter("attributes", this.attributes  );
      }
       if (this.only_child_elements !=null) {
    	  factory.setParameter("only-child-elements", this.only_child_elements   );
      }
      
       if (this.visit_text !=null) {
    	  factory.setParameter("visit-text", this.visit_text  );
      }
       if (this.select_contents !=null) {
    	  factory.setParameter("select-contents", this.select_contents    );
      }
   
      if (this.generate_paths !=null) {
    	  factory.setParameter("generate-paths", this.generate_paths   );
      }
       if (this.diagnose !=null) {
    	  factory.setParameter("diagnose", this.diagnose);
      }
       if (this.terminate !=null) {
    	  factory.setParameter("terminate", this.terminate);
      }

       if (this.schema_id !=null) {
    	  factory.setParameter("schema-id", this.schema_id);
      }
      
       if (this.encoding !=null) {
    	  factory.setParameter("output-encoding", this.encoding);
      } 
       
       if (this.langCode !=null) {
    	  factory.setParameter("langCode", this.langCode);
      } 
       
      
      // Handle Ant logging
      log("Generating validator for schema " + this.schema + "... ", Project.MSG_VERBOSE);
      //xmlCatalog.setProject(getProject());
      
      this.validator = factory.newValidator(new StreamSource(this.schema));
       
      log("Validator ready to process", Project.MSG_VERBOSE);

    } catch (TransformerException ex) {
      log(ex.getMessage());
      SourceLocator locator = ex.getLocator();
      if (locator != null)
        log("SystemID: "+locator.getSystemId()+"; Line#: "+locator.getLineNumber()+"; Column#: "+locator.getColumnNumber());
      throw new BuildException("The validator could not be initialised", ex);
    // exception thrown when try to print preprocessing stylesheet to output file
    } catch (IOException io) {
      log("Error when outputting preprocessor stylesheet: " + io.getMessage());
    } catch (Exception e) {
    	log("Error with initializing validator: " + e.getMessage());
    	e.printStackTrace();
    }
    
  }

  /**
   * Performs the validation for an individual file.
   * 
   * @param afile  The file to validate.
   */
  private SchematronResult doValidate(File afile) {
	  
 
	    
    try {
      log("Validating " + afile.getName() + "... ", Project.MSG_VERBOSE);
      StreamSource xml = new StreamSource(afile);
      SchematronResult result = this.validator.validate(xml, fileNameParameter, fileDirParameter,
    		  archiveNameParameter, archiveDirParameter, encoding);
      
      // Usual return
      return result;

    // exception thrown while trying to generate transformer
    } catch (TransformerConfigurationException ex) {
    	
      throw new BuildException("Could not instantiate validator for document " + afile);

    // exception thrown during transformation
    } catch (TransformerException ex) {
      if (this.failOnError) {
        throw new BuildException("Could not validate document " + afile, ex);
      } else {
    	    System.err.println("DEBUG: error");
        log("Could not validate document " + afile);
        log(ex.getMessage());
        SourceLocator locator = ex.getLocator();
        if (locator != null)
          log("SystemID: "+locator.getSystemId()+"; Line#: "+locator.getLineNumber()+"; Column#: "+locator.getColumnNumber());
      }
    } 
    
    return null;
  }

// Inner classes --------------------------------------------------------------------------------

  /**
   * The Listener class which catches xsl:messages during the transformation of the Schematron
   * schema ????
   */
  private class Listener implements ErrorListener {

    /**
     * {@inheritDoc}
     */
    public void warning(TransformerException ex) {
      SchematronTask.this.log(ex.getMessage());
    }

    /**
     * {@inheritDoc}
     */
    public void error(TransformerException ex) throws TransformerException {
      throw ex;
    }

    /**
     * {@inheritDoc}
     */
    public void fatalError(TransformerException ex) throws TransformerException {
      throw ex;
    }
  }
  
  /*
   * Borrowed from Ant org.apache.tools.ant.taskdefs.XSLTProcess. See LICENSE. 
   */
  
  /**
   * Set the optional classpath to the XSL processor
   *
   * @param classpath the classpath to use when loading the XSL processor
   */
  public void setClasspath(Path classpath) {
      createClasspath().append(classpath);
  }

  /**
   * Set the optional classpath to the XSL processor
   *
   * @return a path instance to be configured by the Ant core.
   */
  public Path createClasspath() {
      if (classpath == null) {
          classpath = new Path(getProject());
      }
      return classpath.createPath();
  }

  /**
   * Set the reference to an optional classpath to the XSL processor
   *
   * @param r the id of the Ant path instance to act as the classpath
   *          for loading the XSL processor
   */
  public void setClasspathRef(Reference r) {
      createClasspath().setRefid(r);
  }

  
      /**
       * Load named class either via the system classloader or a given
       * custom classloader.
       *
       * As a side effect, the loader is set as the thread context classloader
       * @param classname the name of the class to load.
       * @return the requested class.
       * @exception Exception if the class could not be loaded.
       */
      private Class loadClass(String classname) throws Exception {
          if (classpath == null) {
              return Class.forName(classname);
          }
          loader = getProject().createClassLoader(classpath);
          loader.setThreadContextLoader();
          return Class.forName(classname, true, loader);
      }

  
  
}
