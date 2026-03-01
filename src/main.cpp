#include <iostream>
#include <windows.h>
#include <shlobj.h>
#include <filesystem>
#include <fstream>
#include <string>

namespace fs = std::filesystem;

// Function to browse for folder
bool BrowseFolder(std::string& outPath)
{
    BROWSEINFO bi = { 0 };
    bi.lpszTitle = L"Select Resident Evil Requiem installation folder (where RE9.exe is located)";
    bi.ulFlags = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE;

    LPITEMIDLIST pidl = SHBrowseForFolder(&bi);
    if (pidl != 0)
    {
        wchar_t path[MAX_PATH];
        if (SHGetPathFromIDList(pidl, path))
        {
            std::wstring ws(path);
            outPath = std::string(ws.begin(), ws.end());
            return true;
        }
    }
    return false;
}

// Check if RE9.exe exists in folder
bool IsValidGameFolder(const std::string& folder)
{
    fs::path exePath = fs::path(folder) / "RE9.exe";
    return fs::exists(exePath);
}

// Copy file with backup
bool CopyWithBackup(const fs::path& src, const fs::path& dst)
{
    if (fs::exists(dst))
    {
        fs::path backup = dst;
        backup += ".backup";
        try
        {
            fs::copy_file(dst, backup, fs::copy_options::overwrite_existing);
            std::cout << "Backup created: " << backup.filename() << std::endl;
        }
        catch (const std::exception& e)
        {
            std::cerr << "Failed to create backup: " << e.what() << std::endl;
            return false;
        }
    }

    try
    {
        fs::copy_file(src, dst, fs::copy_options::overwrite_existing);
        return true;
    }
    catch (const std::exception& e)
    {
        std::cerr << "Copy failed: " << e.what() << std::endl;
        return false;
    }
}

int main()
{
    SetConsoleTitle(L"RE9 REFramework Installer");
    std::cout << "=========================================\n";
    std::cout << "Resident Evil Requiem REFramework Installer\n";
    std::cout << "=========================================\n\n";

    // Get current executable directory
    wchar_t exePath[MAX_PATH];
    GetModuleFileNameW(NULL, exePath, MAX_PATH);
    fs::path currentDir = fs::path(exePath).parent_path();

    // Find game folder
    std::string gameFolder;
    std::cout << "Select your RE9 installation folder (where RE9.exe is located).\n";
    std::cout << "You can also manually copy files later.\n\n";

    if (BrowseFolder(gameFolder))
    {
        std::cout << "Selected folder: " << gameFolder << std::endl;

        if (!IsValidGameFolder(gameFolder))
        {
            std::cout << "Warning: RE9.exe not found in this folder. Installation may not work.\n";
            std::cout << "Continue anyway? (y/n): ";
            char c;
            std::cin >> c;
            if (c != 'y' && c != 'Y')
            {
                std::cout << "Installation cancelled.\n";
                system("pause");
                return 0;
            }
        }
    }
    else
    {
        std::cout << "No folder selected. Exiting.\n";
        system("pause");
        return 0;
    }

    // Copy dinput8.dll
    fs::path srcDll = currentDir / "dinput8.dll";
    fs::path dstDll = fs::path(gameFolder) / "dinput8.dll";

    if (!fs::exists(srcDll))
    {
        std::cerr << "Error: dinput8.dll not found in installer directory.\n";
        system("pause");
        return 1;
    }

    std::cout << "\nCopying dinput8.dll...\n";
    if (CopyWithBackup(srcDll, dstDll))
        std::cout << "dinput8.dll installed.\n";
    else
    {
        std::cerr << "Failed to copy dinput8.dll.\n";
        system("pause");
        return 1;
    }

    // Create reframework/autorun folder
    fs::path autorunPath = fs::path(gameFolder) / "reframework" / "autorun";
    try
    {
        fs::create_directories(autorunPath);
        std::cout << "Created " << autorunPath << std::endl;
    }
    catch (const std::exception& e)
    {
        std::cerr << "Failed to create directories: " << e.what() << std::endl;
        system("pause");
        return 1;
    }

    // Copy Lua scripts
    fs::path scriptsSrc = currentDir / "scripts";
    if (!fs::exists(scriptsSrc) || !fs::is_directory(scriptsSrc))
    {
        std::cerr << "Error: scripts folder not found in installer directory.\n";
        system("pause");
        return 1;
    }

    std::cout << "\nCopying Lua scripts to reframework/autorun...\n";
    int copied = 0;
    for (const auto& entry : fs::directory_iterator(scriptsSrc))
    {
        if (entry.is_regular_file() && entry.path().extension() == ".lua")
        {
            fs::path dest = autorunPath / entry.path().filename();
            if (CopyWithBackup(entry.path(), dest))
            {
                std::cout << "  " << entry.path().filename() << std::endl;
                copied++;
            }
        }
    }
    std::cout << "Copied " << copied << " scripts.\n";

    std::cout << "\nInstallation complete!\n";
    std::cout << "Launch the game and press INSERT to open REFramework menu.\n";
    std::cout << "\nIf you encounter issues, check that dinput8.dll is in the game folder\n";
    std::cout << "and scripts are in reframework/autorun.\n";

    system("pause");
    return 0;
}