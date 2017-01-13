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

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;
 
import java.util.ArrayList;
/**
 * SAX handler for svrl xml file
 *
 * @author Christophe lauret
 * @author Willy Ekasalim
 * 
 * @version 9 February 2007
 */
  
/**
 * @author Xin Chen
 * @version 20 July 2007
 * TEXT_ELT is not just under FAILED_ASSERT_ELT and SUCCESSFUL_REPORT_ELT.
 * <p> in schematron will also be copied to SVRL as TEXT_ELT
 * Fixed: Make sure the TEXT_ELT parsed under FAILED_ASSERT_ELT and SUCCESSFUL_REPORT_ELT by
 * adding a boolean variable.
 */

public final class SVRLHandler extends DefaultHandler {

// constants --------------------------------------------------------------------------------------

  /**
   * Static name for failed assertions.
   */ 
  private static final String FAILED_ASSERT_ELT = "svrl:failed-assert";

  /**
   * Static name for simple text
   */
  private static final String TEXT_ELT = "svrl:text";

  /**
   * Static name for successful report.
   */
  private static final String SUCCESSFUL_REPORT_ELT = "svrl:successful-report";

  /**
   * Static name for test attribute.
   * Currently not used because test condition are not showed in the console output
   */
  private static final String TEST_ATT = "test";

  /**
   * Static name for location attribute.
   */
  private static final String LOCATION_ATT = "location";

// class attributes -------------------------------------------------------------------------------

  /**
   * StringBuffer to collect text/character data received from characters() callback
   */
  private StringBuffer chars = new StringBuffer();
  
  /**
   * StringBuffer for constructing failed assertion/succesfull message
   */
  private StringBuffer message = new StringBuffer();

  /**
   * String to store the element name that are currently being produced
   */
  private String lastElement;

  /**
   * An ArrayList to store (String) message of failed assertion found.
   */
  private ArrayList<String> failedAssertions;

  /**
   * An ArrayList to store (String) message of successful reports found.
   */
  private ArrayList<String> successfulReports;
  
  /***
   * indicate that the current parsed element is either FAILED_ASSERT_ELT or SUCCESSFUL_REPORT_ELT.
   */
  private boolean underAssertorReport = false;

// contructor -------------------------------------------------------------------------------------

  /**
   * Constructor for SVRLHandler.
   */
  public SVRLHandler() {
  }

  /**
   * Constructor for SVRLHandler that require reference of failedAssertions and successfulReports.
   * @param failedAssertions & successfulReports to store validation message result.
   */
  public SVRLHandler(ArrayList<String> failedAssertions, ArrayList<String> successfulReports) {
    this.failedAssertions = failedAssertions;
    this.successfulReports = successfulReports;
  }

// Handler methods --------------------------------------------------------------------------------

  /**
   * {@inheritDoc}
   */
  public void startElement(String uri, String localName, String rawName, Attributes attributes) {
    // detect svrl:failed-assert and svrl:successful-report element
    if (rawName.equals(FAILED_ASSERT_ELT)) {
      this.message.append("[assert] " + attributes.getValue(LOCATION_ATT));
      this.lastElement = FAILED_ASSERT_ELT;
      underAssertorReport = true;
    } else if (rawName.equals(SUCCESSFUL_REPORT_ELT)) {
      this.message.append("[report] " + attributes.getValue(LOCATION_ATT));
      this.lastElement = SUCCESSFUL_REPORT_ELT;
      underAssertorReport = true;
    } else if (rawName.equals(TEXT_ELT) && underAssertorReport == true) {
      // clean the buffer to start collecting text of svrl:text
      getCharacters();
    }
  }

  /**
   * {@inheritDoc}
   */
  public void endElement(String namespaceURL, String localName, String rawName) {
    // reach the end of svrl:text and collect the text data
    if (rawName.equals(TEXT_ELT) && underAssertorReport == true) {
      this.message.append(" - " + getCharacters());
      //check the last element name to decide where to store the validation message
      if (this.lastElement.equals(FAILED_ASSERT_ELT)) {
        this.failedAssertions.add(getMessage());
      } else {
        this.successfulReports.add(getMessage());	
      }
      underAssertorReport = false;
    }
    this.lastElement = "";
  }

  /**
   * {@inheritDoc}
   */
  public void characters(char[] ch, int start, int length) {
    // print svrl:text text node if the lastElement is svrl:text
    this.chars.append (ch, start, length);
  }

  /**
   * Return the collected text data so far and clean the buffer
   * @return collected text data on the buffer
   */
  private String getCharacters() {
    String retstr = this.chars.toString();
    this.chars.setLength(0);
    return retstr;
  }
  
  /**
   * @return the constructed validation message
   */
  private String getMessage() {
    String retstr = this.message.toString();
    this.message.setLength(0);
    return retstr;
  }

}
