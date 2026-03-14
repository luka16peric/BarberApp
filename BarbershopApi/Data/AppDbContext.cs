using Microsoft.EntityFrameworkCore;
using BarbershopApi.Models;

namespace BarbershopApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        // Ovdje definiramo tablice koje će biti u bazi
        public DbSet<User> Users { get; set; }
        public DbSet<BarberService> Services { get; set; }
        public DbSet<Appointment> Appointments { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // Ovdje možemo dodati dodatna pravila (npr. Email mora biti unikatan)
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();
        }
    }
}