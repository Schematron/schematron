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

import java.io.StringWriter;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

/**
 * An object representing a single Schematron schema, used to validate multiple XML instances.
 *
 * @author Christophe Lauret
 * @author Willy Ekasalim
 * @author Rick Jelliffe
 * 
 * @version 14 February 2010
 */
public final class Validator {

  /**
   * The generated Schematron validator transformer templates.
   */
  private final Templates validator;

  /**
   * Constructs a new Validator object for a given Schematron templates.
   * 
   * @param templates The Schematron templates.
   * 
   * @throws IllegalArgumentException If the templates are <code>null</code>.
   */
  protected Validator(Templates templates) throws IllegalArgumentException {
    if (templates == null)
      throw new IllegalArgumentException("A validator cannot be constructed with null templates");
    this.validator = templates;
  }

// public methods ----------------------------------------------------------------------------------

  /**
   * Performs validation of the passed XML data.
   *
   * @param xml    The XML data to be validated.
   * @param fnp	   the file name if available separately
   * @param fdp		the file directory path or the whole system identifier otherwise
   * ?@?param report The Schematron report collecting results for each file.
   * 
   * @throws TransformerConfigurationException Should an error occur while instantiating a transformer. 
   * @throws TransformerException              If an error occurs while performing the transformation.
   */
  public SchematronResult validate(Source xml, String fnp, String fdp, String anp, String adp, String encoding) throws TransformerConfigurationException, TransformerException {
    Transformer transformer = this.validator.newTransformer();
    
    if (encoding != null && encoding.length() > 0 ) {
    	transformer.setOutputProperty( OutputKeys.ENCODING, encoding);
    }
    transformer.setOutputProperty("indent","yes"); 
    
    
    String sid = xml.getSystemId();
    String aid = "";
    if ( sid.startsWith("jar:") || sid.startsWith("zip:")) {
    	aid = sid.substring(0,   
    			sid.lastIndexOf("!" ));
    		
    	sid =
    		sid.substring(   
        			sid.lastIndexOf("!" )+1);
    }

    if (anp != null && anp.length() > 0)
    	transformer.setParameter("archiveNameParameter", anp);
    else if (aid != null && aid.length() > 0){
    	transformer.setParameter("archiveNameParameter", 
    		aid.substring(   
    			aid.lastIndexOf("/" )+1)  );
    }
        if (adp != null && adp.length() > 0)
            transformer.setParameter("archiveDirParameter", adp);
        else if (aid != null && aid.length() > 0
        		   && aid.lastIndexOf("/" )> -1){
        	transformer.setParameter("archiveDirParameter", 
            		aid.substring(0,   
            			aid.lastIndexOf("/" )));
        } 
    // provide the filenames
    if (fnp != null && fnp.length() > 0)
    	transformer.setParameter("fileNameParameter", fnp);
    else if (sid != null && sid.length() > 0){
    	transformer.setParameter("fileNameParameter", 
    		sid.substring(   
    			sid.lastIndexOf("/" )+1)  );
    } 
     	
    if (fdp != null && fdp.length() > 0)
        transformer.setParameter("fileDirParameter", fdp);
    else if (sid != null && sid.length() > 0
    		   && sid.lastIndexOf("/" )> -1){
    	transformer.setParameter("fileDirParameter", 
        		sid.substring(0,   
        			sid.lastIndexOf("/" )));
    } 
       
    
    StringWriter writer = new StringWriter();
    transformer.transform(xml, new StreamResult(writer));
    SchematronResult result = new SchematronResult(xml.getSystemId());
    result.setSVRL(writer.toString());
    return result;
  }

}
