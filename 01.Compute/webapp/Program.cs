using System.Net;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var app = builder.Build();

// Configure the HTTP request pipeline.

app.MapGet("/", () =>
{
    var hostName = Dns.GetHostName();
    var response = "Hello World! \nVersion 1.0\nHostname: " + hostName + "\n";
    return response;
});

app.Run();