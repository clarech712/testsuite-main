#include <TH1F.h>
#include <TFile.h>
#include <TCanvas.h>
#include <iostream>
#include <fstream>

void create_histogram() {
    // Create a histogram with 10 bins from 0 to 5
    TH1F *hist = new TH1F("hist", "Example Histogram", 10, 0, 5);

    // Optional: Read data from file and fill the histogram
    std::ifstream infile("data.txt");
    double value;
    while (infile >> value) {
        hist->Fill(value);
    }

    // Save the histogram to a ROOT file
    TFile *file = new TFile("histogram_output.root", "RECREATE");
    hist->Write();
    file->Close();

    // Print a success message
    std::cout << "Histogram has been saved to histogram_output.root" << std::endl;
}

