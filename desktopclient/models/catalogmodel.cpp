#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QQmlContext>
#include "kernel.h"
#include "connectorinterface.h"
#include "resource.h"
#include "ilwisobject.h"
#include "mastercatalog.h"
#include "catalogview.h"
#include "resourcemodel.h"
#include "catalogmodel.h"


using namespace Ilwis;
//using namespace Desktopclient;

CatalogModel::CatalogModel()
{
    //_hasChilderen = false;
    _initNode = false;
    _level = 0;
    _isScanned = false;
}

CatalogModel::CatalogModel(const CatalogView &view, int lvl, QObject *parent) : ResourceModel(view.resource(), parent)
{
    _initNode = true;
    _level = lvl;
    _isScanned = true;
    newview(view);

}

void CatalogModel::newview(const CatalogView &view){
    _view = view;
    mastercatalog()->addContainer(view.resource().url().toString());
    _displayName = view.resource().name();
    if ( _displayName == sUNDEF)
        _displayName = view.resource().url().toString();
}

bool CatalogModel::isScanned() const
{
    return _isScanned;
}

bool CatalogModel::initNode() const {
    return _initNode;
}

int CatalogModel::level() const
{
    return _level;
}

QQmlListProperty<ResourceModel> CatalogModel::resources() {

    try{
        gatherItems();

        return  QQmlListProperty<ResourceModel>(this, _currentItems);
    }
    catch(const ErrorObject& err){

    }
    return  QQmlListProperty<ResourceModel>();
}

void CatalogModel::filterChanged(const QString& objectType, bool state){
    _filterState[objectType] = state;
    QString filterString;
    for(auto iter : _filterState){
        if ( !iter.second){
            if ( filterString != "")
                filterString += " and ";
            filterString += QString("type") + "<>'" + objectType + "'";
        }
    }
    _refresh = true;
    _view.filter(filterString);
}

void CatalogModel::gatherItems() {
    if ( _currentItems.isEmpty() || _refresh) {
        if ( !_view.isValid())
            return;

        _view.prepare();

        //for(ResourceModel *model : _currentItems)
        //    delete model;

        _currentItems.clear();
        _refresh = false;

        std::vector<Resource> items = _view.items();
        for(const Resource& resource : items){
            _currentItems.push_back(new ResourceModel(resource));
        }
    }
}



