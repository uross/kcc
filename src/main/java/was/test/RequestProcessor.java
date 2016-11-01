package was.test;

import java.io.*;
import java.net.Socket;
import java.net.URLConnection;
import java.nio.file.Files;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RequestProcessor implements Runnable {
    private final static Logger logger = Logger.getLogger(RequestProcessor.class.getCanonicalName());
    private File rootDirectory;
    private Socket connection;
    private String uri;
    
    
    public RequestProcessor(File rootDirectory,   Socket connection) {
        if (rootDirectory.isFile()) {
            throw new IllegalArgumentException(
                    "rootDirectory must be a directory, not a file");
        }
        try {
            rootDirectory = rootDirectory.getCanonicalFile();
        	} catch (IOException ex) {
        }
        this.rootDirectory = rootDirectory;
        
        this.connection = connection;
    }

    @Override
    public void run() {
        // for security checks
        String root = rootDirectory.getPath();
        
        
        
        
        try {
            OutputStream raw = new BufferedOutputStream(connection.getOutputStream());
            Writer out = new OutputStreamWriter(raw);
            Reader in = new InputStreamReader(new BufferedInputStream(connection.getInputStream()), "UTF-8");
            StringBuilder requestLine = new StringBuilder();
            StringBuilder requestLine2 = new StringBuilder();
            
            
            //bufferedReader.close();
            
            System.out.println("111111");
            
            in = new InputStreamReader(new BufferedInputStream(connection.getInputStream()), "UTF-8");

            System.out.println("2222");
            while (true) {
                int c = in.read();
                if (c == '\r' || c == '\n')
                    break;
                requestLine.append((char) c);
            }
            System.out.println("3333");
            uri = parseUri(requestLine.toString());
            
            String get = requestLine.toString();
            logger.info(connection.getRemoteSocketAddress() + " " + get);
            String[] tokens = get.split("\\s+");
            String method = tokens[0];
            
            
            
            String version = "";
            
            
            if (method.equals("GET")) {
                String fileName = tokens[1];
                if (fileName.endsWith("/")) fileName += uri;
                String contentType =
                        URLConnection.getFileNameMap().getContentTypeFor(fileName);
                if (tokens.length > 2) {
                    version = tokens[2];
                }
                File theFile = new File(rootDirectory, fileName.substring(1, fileName.length()));
                if (theFile.canRead()
// Don't let clients outside the document root
                        && theFile.getCanonicalPath().startsWith(root)) {
                    byte[] theData = Files.readAllBytes(theFile.toPath());
                    if (version.startsWith("HTTP/")) { // send a MIME header
                        sendHeader(out, "HTTP/1.0 200 OK", contentType, theData.length);
                    }
                    // send the file; it may be an image or other binary data
                    // so use the underlying output stream
                    // instead of the writer
                    raw.write(theData);
                    raw.flush();
                } else {
                    // can't find the file
                    String body = new StringBuilder("<HTML>\r\n")
                            .append("<HEAD><TITLE>File Not Found</TITLE>\r\n")
                            .append("</HEAD>\r\n")
                            .append("<BODY>")
                            .append("<H1>HTTP Error 404: File Not Found</H1>\r\n")
                            .append("</BODY></HTML>\r\n")
                            .toString();
                    if (version.startsWith("HTTP/")) { // send a MIME header
                        sendHeader(out, "HTTP/1.0 404 File Not Found", "text/html; charset=utf-8", body.length());
                    }
                    out.write(body);
                    out.flush();
                }
            } else {
                // method does not equal "GET"
                String body = new StringBuilder("<HTML>\r\n").append("<HEAD><TITLE>Not Implemented</TITLE>\r\n").append("</HEAD>\r\n")
                        .append("<BODY>")
                        .append("<H1>HTTP Error 501: Not Implemented</H1>\r\n")
                        .append("</BODY></HTML>\r\n").toString();
                if (version.startsWith("HTTP/")) { // send a MIME header
                    sendHeader(out, "HTTP/1.0 501 Not Implemented",
                            "text/html; charset=utf-8", body.length());
                }
                out.write(body);
                out.flush();
            }
        } catch (IOException ex) {
            logger.log(Level.WARNING, "Error talking to " + connection.getRemoteSocketAddress(), ex);
        } finally {
            try {
                connection.close();
            } catch (IOException ex) {
            }
        }
    }

    private void sendHeader(Writer out, String responseCode, String contentType, int length)
            throws IOException {
        out.write(responseCode + "\r\n");
        Date now = new Date();
        out.write("Date: " + now + "\r\n");
        out.write("Server: JHTTP 2.0\r\n");
        out.write("Content-length: " + length + "\r\n");
        out.write("Content-type: " + contentType + "\r\n\r\n");
        out.flush();
    }
    
	public String parseUri(String requestStr) {

		int index1, index2;

		index1 = requestStr.indexOf(' ');

 
		if (index1 != -1) {
			index2 = requestStr.indexOf(' ', index1 + 1);
			if (index2 > index1) {

 				return requestStr.substring(index1 + 1, index2);

			}
		}

		return null;

	}

	public String getUri() {
		return uri;
	}
	
	


}