#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/dom/DOM.hpp>
#include <xercesc/sax/HandlerBase.hpp>
#include <xercesc/util/XMLString.hpp>
#include <iostream>

using namespace xercesc;

int main(int argc, char* argv[]) {
    try {
        XMLPlatformUtils::Initialize();
    }
    catch (const XMLException& toCatch) {
        char* message = XMLString::transcode(toCatch.getMessage());
        std::cerr << "Error during initialization! :\n"
                  << message << "\n";
        XMLString::release(&message);
        return 1;
    }

    XercesDOMParser* parser = new XercesDOMParser();
    parser->setValidationScheme(XercesDOMParser::Val_Never);
    parser->setDoNamespaces(false);
    parser->setDoSchema(false);
    parser->setLoadExternalDTD(false);

    try {
        parser->parse("example.xml");
    }
    catch (const XMLException& toCatch) {
        char* message = XMLString::transcode(toCatch.getMessage());
        std::cerr << "Exception message is: \n"
                  << message << "\n";
        XMLString::release(&message);
        return -1;
    }
    catch (const DOMException& toCatch) {
        char* message = XMLString::transcode(toCatch.msg);
        std::cerr << "Exception message is: \n"
                  << message << "\n";
        XMLString::release(&message);
        return -1;
    }
    catch (...) {
        std::cerr << "Unexpected Exception \n";
        return -1;
    }

    DOMDocument* doc = parser->getDocument();
    DOMElement* rootElement = doc->getDocumentElement();

    if (rootElement) {
        DOMNodeList* children = rootElement->getChildNodes();
        const XMLSize_t nodeCount = children->getLength();
        for (XMLSize_t i = 0; i < nodeCount; ++i) {
            DOMNode* currentNode = children->item(i);
            if (currentNode->getNodeType() && currentNode->getNodeType() == DOMNode::ELEMENT_NODE) {
                DOMElement* currentElement = dynamic_cast<xercesc::DOMElement*>(currentNode);
                char* name = XMLString::transcode(currentElement->getTagName());
                char* value = XMLString::transcode(currentElement->getTextContent());
                std::cout << "Element: " << name << ", Value: " << value << std::endl;
                XMLString::release(&name);
                XMLString::release(&value);
            }
        }
    }

    delete parser; // Use delete instead of release
    XMLPlatformUtils::Terminate();
    return 0;
}

