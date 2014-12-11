#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include "applicationui.h"
#include "utility.h"
#include "myhttprequest.h"
using namespace bb::cascades;

ApplicationUI::ApplicationUI(bb::cascades::Application *app) :
    QObject(app)
{
    // By default the QmlDocument object is owned by the Application instance
    // and will have the lifespan of the application
    QmlDocument *qml = QmlDocument::create("asset:///blackberry/main.qml");
    // Create root object for the UI
    Utility *utility = Utility::createUtilityClass();
    qml->setContextProperty("utility", utility);
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    app->setScene(root);
}




