using BarbershopApi.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// 1. DODAJ CORS (Ovo je ključno za iPhone/Swift!)
builder.Services.AddCors(options => {
    options.AddPolicy("AllowSwiftUI", policy => {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Registracija baze podataka (SQLite)
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite("Data Source=barbershop.db"));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Konfiguracija HTTP cjevovoda
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// 2. AKTIVIRAJ CORS (Mora biti iznad UseAuthorization i MapControllers)
app.UseCors("AllowSwiftUI");

// app.UseHttpsRedirection(); // SAVJET: Ako testiraš lokalno, nekad je lakše zakomentirati ovo dok ne središ certifikate na iPhoneu

app.UseAuthorization();

app.MapControllers();

app.Run();