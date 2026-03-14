var builder = WebApplication.CreateBuilder(args);

// 1. Registriraj kontrolere (ovo omogućuje rad mape Controllers)
builder.Services.AddControllers();

// Swagger postavke
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// 2. Konfiguracija za razvoj (Swagger)
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// 3. RECI APLIKACIJI DA KORISTI KONTROLERE
// Ovo će automatski pronaći tvoj ServicesController
app.MapControllers(); 

app.Run();