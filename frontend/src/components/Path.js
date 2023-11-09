const app_name = 'wheeldeals-d3e9615ad014'
exports.buildPath =
function buildPath(route)
{
    if (process.env.NODE_ENV === "production") 
    {
        return "https://" + app_name + ".herokuapp.com/" + route;
    } else 
    {
        return "http://localhost:9000/" + route;
    }
}

// export default buildPath;