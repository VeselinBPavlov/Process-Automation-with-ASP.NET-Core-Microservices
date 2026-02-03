FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["CarRentalSystem.Notifications/CarRentalSystem.Notifications.csproj", "CarRentalSystem.Notifications/"]
COPY ["CarRentalSystem/CarRentalSystem.csproj", "CarRentalSystem/"]
COPY ["Directory.Build.props", "."]
COPY ["Directory.Packages.props", "."]
RUN dotnet restore "CarRentalSystem.Notifications/CarRentalSystem.Notifications.csproj"
COPY . .
WORKDIR "/src/CarRentalSystem.Notifications"
RUN dotnet build "CarRentalSystem.Notifications.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CarRentalSystem.Notifications.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CarRentalSystem.Notifications.dll"]